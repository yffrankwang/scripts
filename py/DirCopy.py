#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import fnmatch
import os
import sys
import getopt

class DirCopy:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = ''
		self.desdir = ''
		self.matchs = []
		self.test = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "DirCopy.py [Options] srcdir desdir"
		print 
		print "Options (takes an parameter):"
		print " -m, --match     Directory name match"
		print 
		print "Flags (no parameter):"
		print " -t, --test      Test only (do not create directory)" 
		print 
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?m:t", 
				[ "help", "match=", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--match", "-m"):
					self.match.append(arg)
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if len(args) < 1:
			self.showUsage("Missing srcdir argument!")
		self.srcdir = args[0]
		
		if len(args) < 2:
			self.showUsage("Missing desdir argument!")
		self.desdir = args[1]

	def run(self):
		print 'DirCopy (%s) %s -> %s' % (self.matchs, self.srcdir, self.desdir)
		self.process(self.srcdir, self.desdir)
		print 'OK!'

	def process(self, srcdir, desdir):
		for fn in os.listdir(srcdir):
			if fn[0] == '.':
				continue

			if not os.path.isdir(os.path.join(srcdir, fn)):
				continue
			
			if self.matchs:
				for p in self.matchs:
					if fnmatch.fnmatch(fn, p):
						self.copydir(srcdir, desdir, fn)
			else:
				self.copydir(srcdir, desdir, fn)

	def copydir(self, srcdir, desdir, fn):
		nsrc = os.path.join(srcdir, fn)
		ndes = os.path.join(desdir, fn)

		if os.path.exists(ndes):
			print "SKIP " + ndes
			return

		if self.test:
			print "TEST " + ndes
			return

		sys.stdout.write("Create %s ... " % ndes)
		try:
			os.makedirs(ndes)
		except Exception as e:
			print "FAILED"
			print e
			sys.exit(1)
		print "OK"

		self.process(nsrc, ndes)

	
# start
if __name__ == "__main__":
	dc = DirCopy()
	
	dc.getArgs(sys.argv[1:])
	dc.run()

	sys.exit(0)
