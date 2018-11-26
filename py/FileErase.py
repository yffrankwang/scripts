#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#

import fnmatch
import getopt
import os
import sys


if sys.version_info >= (3, 0):
	def raw_input(s):
		return input(s)

class FileEraser:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcdir = '.'
		self.recu = False
		self.execu = False
		self.quiet = False


	def showUsage(self, err=None, exitCode=2):
		if err:
			print("Error: " + err)
			print("")
		print("FileErase.py [Options] file1 file2 ...")
		print("Options (takes an parameter):")
		print(" -s, --srcdir    Source Directory (default: %s)" % self.srcdir)
		print("")
		print("Flags (no parameter):")
		print(" -r, --recu      Recursively erase files in subdirectores")
		print(" -e, --exec      Erase file without prompt")
		print(" -q, --quiet     Do not show prompt")
		print("")

		if exitCode > 0:
			sys.exit(exitCode)


	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:req",
				[ "help", "srcdir=", "recu", "exec", "quiet" ]
				)

			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--srcdir", "-s"):
					self.srcdir = arg
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


	def run(self):
		print('FileErase %s: %s' % (self.srcdir, self.files))
		if self.execu:
			self.process(self.srcdir)
			return

		n = self.process(self.srcdir)
		if n == 0 or self.quiet:
			return

		a = raw_input("Are you sure to erase %d files? (Y/N): " % n)
		if a.lower() == "y":
			self.execu = True
			self.process(self.srcdir)


	def process(self, srcdir):
		n = 0
		for fn in os.listdir(srcdir):
			if os.path.isdir(os.path.join(srcdir, fn)):
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					n += self.process(nsrc)
					self.rmdir(nsrc)
			else:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						self.erase(srcdir, fn)
						n += 1
		return n


	def rmdir(self, path):
		if self.execu:
			try:
				os.rmdir(path)
			except Exception as e:
				print("Failed to remove %s: %s" % (path, str(e)))
		
	def erase(self, srcdir, fn):
		sf = os.path.join(srcdir, fn)

		sys.stdout.write(" [ERASE] %s ... " % (sf))

		msg = "?"
		if self.execu:
			msg = "OK"

			# read size
			sz = os.path.getsize(sf)
			if sz > 0:
				# empty string
				s = ''.ljust(1024, ' ')
				try:
					with open(sf, 'r+b') as f:
						while sz > 0:
							f.write(s)
							sz -= 1024
				except Exception as e:
					msg = str(e)
			# remove
			os.remove(sf)

		print("[%s]" % (msg))


# start
if __name__ == "__main__":
	ec = FileEraser()

	ec.getArgs(sys.argv[1:])
	ec.run()

	sys.exit(0)
