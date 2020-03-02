#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import fnmatch
import os
import sys
import getopt
import re

if sys.version_info >= (3, 0):
	def raw_input(s):
		return input(s)

EOL_LF   = 0x0001
EOL_CR   = 0x0002
EOL_CRLF = 0x0004

class FileEolSet:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcdir = '.'
		self.eola = EOL_LF
		self.eols = "\n"
		self.recu = False
		self.execu = False
		self.quiet = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print("")
		print("FileEolSet.py [Options] file1 file2 ...")
		print("")
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print(" -l, --eol       End of Line (LF:default, CR, CRLF)")
		print("")
		print("Flags (no parameter):")
		print(" -r, --recu      Recursively change date of files in subdirectores")
		print(" -e, --exec      Execute file EOL change without prompt")
		print(" -q, --quiet     Do not show prompt")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:l:req", 
				[ "help", "src=", "eol=", "recu", "exec", "quiet" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--eol", "-l"):
					a = arg.upper()
					if a == 'CR':
						self.eols = "\r"
						self.eola = EOL_CR
					elif a == 'LF':
						self.eols = "\n"
						self.eola = EOL_LF
					elif a == 'CRLF':
						self.eols = "\r\n"
						self.eola = EOL_CRLF
					else:
						self.showUsage("Invalid argument: " + opt)
				elif opt in ("--dir", "-d"):
					self.dir = True
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--exec", "-e"):
					self.execu = True
				elif opt in ("--quiet", "-q"):
					self.quiet = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		self.files = args
		if not self.files:
			self.files = [ '*' ]

	def eol(self, eola):
		if eola == EOL_CR:
			return 'CR'
		if eola == EOL_LF:
			return 'LF'
		if eola == EOL_CRLF:
			return 'CRLF'
		return 'MIXED'

	def run(self):
		print('FileEolSet %s/%s (%s)' % (self.srcdir, self.files, self.eol(self.eola)))
		if self.execu:
			self.process(self.srcdir)
			return

		n = self.process(self.srcdir)
		if n == 0 or self.quiet:
			return

		a = raw_input("Are you sure to change EOL of %d files? (Y/N): " % n)
		if a.lower() == "y":
			self.execu = True
			self.process(self.srcdir)


	def process(self, srcdir):
		if not os.access(srcdir, os.W_OK):
			return 0
		
		n = 0
		for fn in os.listdir(srcdir):
			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					n += self.process(nsrc)
			else:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						if self.eolset(srcdir, fn):
							n += 1
		return n

	def eolset(self, srcdir, sfn):
		sf = os.path.join(srcdir, sfn)
		
		sz = os.path.getsize(sf)
		if sz > 1024 * 1024 * 20:
			print('[FAILED] %s: file size %d is too big.' % (sf, sz))
			return False

		if sz < 1:
			return False

		sd = ''
		with open(sf, "rb") as f:
			sd = f.read()
		
		sz = len(sd)
		oeol = 0
		i = 0
		while i < sz:
			c = sd[i]
			if c == "\r":
				if i < sz - 1 and sd[i + 1] == "\n":
					i += 1
					oeol |= EOL_CRLF
				else:
					oeol |= EOL_CR
			elif c == "\n":
				oeol |= EOL_LF
			i += 1

		if oeol == 0 or oeol == self.eola:
			return False

		sys.stdout.write('[EOLSET] %s: %s -> %s ... ' % (sf, self.eol(oeol), self.eol(self.eola)))
		msg = '?'
		if self.execu:
			nsd = ''
			i = 0
			while i < sz:
				c = sd[i]
				i += 1
				if c == "\r":
					nsd += self.eols
					if i < sz and sd[i] == "\n":
						i = i + 1
				elif c == "\n":
					nsd += self.eols
				else:
					nsd += c
	
			with open(sf, "wb") as f:
				f.write(nsd)
			msg = 'OK'

		print('[%s]' % msg)
		return True

# start
if __name__ == "__main__":
	fr = FileEolSet()
	
	fr.getArgs(sys.argv[1:])
	fr.run()

	sys.exit(0)
