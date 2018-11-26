#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#
	
import os
import sys
import getopt

class FileSplitter:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcFile = None
		self.outDir = None
		self.divSize = 1024 * 1024


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "FileSplit.py [Options] file"
		print "Options (takes an parameter):"
		print " -o, --outd      Output Directory"
		print " -s, --size      Split Size (default: %d)" % self.divSize
		print 
		print "Flags (no parameter):"
		print " -v, --verbose   Verbose output"
		
		if exitCode > 0:
			sys.exit(exitCode)
	
	def getSize(self, arg):
		if not arg:
			raise Exception('Invalid split size: ' + arg)
		
		u = arg[-1].upper()
		if u == 'G':
			return int(arg[0:-1]) * 1024 * 1024 * 1024
		elif u == 'M':
			return int(arg[0:-1]) * 1024 * 1024
		elif u == 'M':
			return int(arg[0:-1]) * 1024
		else:
			return int(arg)

	def getArguments(self, args):
		try:
			opts, args = getopt.getopt(args, "h?o:s:", 
				[ "help", "outd=", "size=" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--outd", "-o"):
					self.outDir = arg
				elif opt in ("--size", "-s"):
					self.divSize = self.getSize(arg)
				else:
					self.showUsage("Invalid argument: " + opt)
		
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if args:
			self.srcFile = args[0]

		if not self.srcFile:
			self.showUsage("Missing argument: file")


	def run(self):
		print("Split file: %s (%d)" % (self.srcFile, self.divSize))

		if not self.outDir:
			self.outDir = os.path.dirname(self.srcFile)
		
		fnPre, fnExt = os.path.splitext(self.srcFile)
		fnBase = os.path.basename(fnPre)
		
		fileno = 0
		with open(self.srcFile, 'rb') as f:
			while True:
				s = f.read(self.divSize)
				if len(s) == 0:
					break;

				fileno += 1
				fn = os.path.join(self.outDir, "%s.%04d%s" % (fnBase, fileno, fnExt))
				print(fn)
				with open(fn, "w") as df:
					df.write(s)

		print "OK!"

# start
if __name__ == "__main__":
	fs = FileSplitter()
	
	fs.getArguments(sys.argv[1:])
	fs.run()

	sys.exit(0)
