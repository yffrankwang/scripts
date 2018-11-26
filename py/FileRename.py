#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import fnmatch
import os
import sys
import getopt
import re
import time

if sys.version_info >= (3, 0):
	def raw_input(s):
		return input(s)

class FileRenamer:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcdir = '.'
		self.index = -1
		self.text = ''
		self.repl = ''
		self.pattern = ''
		self.timefmt = '%Y%m%d_%H%M%S'
		self.regex = None
		self.dir = False
		self.recu = False
		self.execu = False
		self.quiet = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print('')
		print("FileRename.py [Options] file1 file2 ...")
		print("")
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print(" -t, --text      Source Text")
		print(" -x, --regex     Source regex expression")
		print(" -i, --index     Source Index")
		print(" -p, --repl      Replace Text (default: '%s')" % self.repl)
		print(" -P, --pattern   Rename pattern")
		print("     PATTERN: ")
		print("       %n:      File name")
		print("       %e:      File extension")
		print("       %t:      File date")
		print(" -T, --timefmt   Time format (default: %s)" % self.timefmt)
		print("")
		print("Flags (no parameter):")
		print(" -d, --dir       Rename directory")
		print(" -r, --recu      Recursively rename files in subdirectores")
		print(" -e, --exec      Execute file rename process without prompt")
		print(" -q, --quiet     Do not show prompt")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:t:x:i:p:P:T:dreq", 
				[ "help", "src=", "text=", "regex=", "index=", "repl=", "pattern=", "timefmt=", "dir", "recu", "exec", "quiet" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--text", "-t"):
					self.text = arg
				elif opt in ("--regex", "-x"):
					self.regex = re.compile(arg)
				elif opt in ("--index", "-i"):
					self.index = int(arg)
				elif opt in ("--repl", "-p"):
					self.repl = arg
				elif opt in ("--pattern", "-P"):
					self.pattern = arg
				elif opt in ("--timefmt", "-T"):
					self.timefmt = arg
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

		if not (self.text or self.regex or self.index > -1 or self.pattern):
			self.showUsage("Missing --text or --regex or --index or --pattern argument!")

	def run(self):
		print('FileRename %s/%s (%s) -> (%s)' % (self.srcdir, self.files, self.regex.pattern if self.regex else self.text, self.pattern if self.pattern else self.repl))
		if self.execu:
			self.process(self.srcdir)
			return

		n = self.process(self.srcdir)
		if n == 0 or self.quiet:
			return

		a = raw_input("Are you sure to rename %d files? (Y/N): " % n)
		if a.lower() == "y":
			self.execu = True
			self.process(self.srcdir)


	def process(self, srcdir):
		if not os.access(srcdir, os.W_OK):
			return 0
		
		n = 0
		for fn in os.listdir(srcdir):
			ren = False
			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					n += self.process(nsrc)
				ren = self.dir
			else:
				ren = not self.dir

			if ren:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						if self.rename(srcdir, fn):
							n += 1
		return n

	def rename(self, srcdir, sfn):
		dfn = sfn
		if self.pattern:
			tm = time.strftime(self.timefmt, time.localtime(os.path.getmtime(os.path.join(srcdir, sfn))))
			fn = os.path.splitext(sfn)
			dfn = self.pattern.replace("%n", fn[0]).replace("%e", fn[1]).replace("%t", tm)
		elif self.regex:
			dfn = self.regex.sub(self.repl, sfn)
		elif self.index > -1:
			dfn = sfn[0:self.index] + self.repl + sfn[self.index:]
		else:
			dfn = sfn.replace(self.text, self.repl)

		if dfn != sfn:
			sf = os.path.join(srcdir, sfn)
			df = os.path.join(srcdir, dfn)
			
			if os.path.exists(df):
				print(" [FAILED] %s -> %s ... [File Already Exists]" % (sf, dfn))
				return False

			sys.stdout.write(" [RENAME] %s -> %s ... " % (sf, dfn))
			msg = "?"
			if self.execu:
				msg = "OK"
				try:
					os.rename(sf, df)
				except Exception as e:
					msg = str(e)
			print("[%s]" % (msg))
			return True
		
		return False


# start
if __name__ == "__main__":
	fr = FileRenamer()
	
	fr.getArgs(sys.argv[1:])
	fr.run()

	sys.exit(0)
