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

class DelEmptyDir:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = '.'
		self.execu = False
		self.quiet = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print('')
		print("DelEmptyDir.py [Options] file1 file2 ...")
		print("")
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print("")
		print("Flags (no parameter):")
		print(" -e, --exec      Delete empty directories without prompt")
		print(" -q, --quiet     Do not show prompt")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:eq", 
				[ "help", "src=", "exec", "quiet" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--exec", "-e"):
					self.execu = True
				elif opt in ("--quiet", "-q"):
					self.quiet = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))


	def run(self):
		print('DelEmptyDir %s' % (self.srcdir))
		
		if self.execu:
			self.process(self.srcdir)
			return

		n = self.process(self.srcdir)
		if n == 0 or self.quiet:
			return

		a = raw_input("Are you sure to delete %d directories? (Y/N): " % n)
		if a.lower() == "y":
			self.execu = True
			self.process(self.srcdir)


	def process(self, srcdir):
		if not os.access(srcdir, os.W_OK):
			return 0

		f = 0
		n = 0
		for fn in os.listdir(srcdir):
			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				nsrc = os.path.join(srcdir, fn)
				n += self.process(nsrc)
			f += 1

		if f == 0:
			if self.remove(srcdir):
				n += 1
		return n
		
	def remove(self, srcdir):
		sys.stdout.write(" [REMOVE] %s ... " % (srcdir))
		msg = "?"
		if self.execu:
			msg = "OK"
			try:
				os.rmdir(srcdir)
			except Exception as e:
				msg = str(e)
		print("[%s]" % (msg))
		return True


# start
if __name__ == "__main__":
	fr = DelEmptyDir()
	
	fr.getArgs(sys.argv[1:])
	fr.run()

	sys.exit(0)
