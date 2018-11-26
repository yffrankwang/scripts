#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import fnmatch
import os
import sys
import getopt
import re
import jsbeautifier

class JsBeatufier:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcdir = '.'
		self.back = False
		self.recu = False
		self.test = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "JsBeatufier.py [Options] file1 file2 ..."
		print 
		print "Options (takes an parameter):"
		print " -s, --src       Source Directory (default: %s)" % self.srcdir
		print 
		print "Flags (no parameter):"
		print " -b, --back      Backup source file"
		print " -r, --recu      Recursively rename files in subdirectores"
		print " -t, --test      Test only (do not rename the file)" 
		print 
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:brt", 
				[ "help", "src=", "back", "recu", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--back", "-b"):
					self.back = True
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		self.files = args
		if not self.files:
			self.files = [ '*.js' ]
				
	def run(self):
		print 'JsBeatufier %s/%s' % (self.srcdir, self.files)
		self.process(self.srcdir)
		print 'OK!'

	def process(self, srcdir):
		if not os.access(srcdir, os.W_OK):
			return
		
		for fn in os.listdir(srcdir):
			if os.path.isdir(os.path.join(srcdir, fn)):
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					self.process(nsrc)

			for p in self.files:
				if fnmatch.fnmatch(fn, p):
					self.jsbeautify(srcdir, fn)

	def jsbeautify(self, srcdir, sfn):
		sf = os.path.join(srcdir, sfn)
		bf = sf + ".bak"
		while os.path.exists(bf):
			bf += ".bak"
		
		
		msg = "TEST"
		try:
			if not self.test:
				os.rename(sf, bf)
				with open(sf, 'w') as f:
					f.write(jsbeautifier.beautify_file(bf))
				
				if not self.back:
					os.remove(bf)

				msg = "OK"
		except Exception, e:
			msg = str(e)

		print "jsbeautify %s ... [%s]" % (sf, msg)


# start
if __name__ == "__main__":
	jb = JsBeatufier()
	
	jb.getArgs(sys.argv[1:])
	jb.run()

	sys.exit(0)
