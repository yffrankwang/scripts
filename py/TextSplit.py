#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#
	
import os
import sys
import getopt

class TextSplitter:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcFile = None
		self.outDir = None
		self.divLine = 100000


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "TextSplit.py [Options] file"
		print "Options (takes an parameter):"
		print " -o, --outd      Output Directory"
		print " -l, --line      Line Count / File (default: %d)" % self.divLine
		print 
		print "Flags (no parameter):"
		print " -v, --verbose   Verbose output"
		
		if exitCode > 0:
			sys.exit(exitCode)
	

	def getArguments(self, args):
		try:
			opts, args = getopt.getopt(args, "h?o:l:", 
				[ "help", "outd=", "line=" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--outd", "-o"):
					self.outDir = arg
				elif opt in ("--line", "-l"):
					self.divLine = int(arg)
				else:
					self.showUsage("Invalid argument: " + opt)
		
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if args:
			self.srcFile = args[0]

		if not self.srcFile:
			self.showUsage("Missing argument: file")


	def run(self):
		print("Split file: %s (%d)" % (self.srcFile, self.divLine))

		if not self.outDir:
			self.outDir = os.path.dirname(self.srcFile)
		
		fnPre, fnExt = os.path.splitext(self.srcFile)
		fnBase = os.path.basename(fnPre)
		
		divFile = None
		fileno = 0
		lineno = 0
		with open(self.srcFile) as f:
			for line in f:
				if lineno % self.divLine == 0:
					if divFile:
						divFile.close()
					fileno += 1
					fn = os.path.join(self.outDir, "%s.%04d%s" % (fnBase, fileno, fnExt))
					print(fn)
					divFile = open(fn, "w")
				
				divFile.write(line)
				lineno += 1

		if divFile:
			divFile.close()

		print "OK!"

# start
if __name__ == "__main__":
	fs = TextSplitter()
	
	fs.getArguments(sys.argv[1:])
	fs.run()

	sys.exit(0)
