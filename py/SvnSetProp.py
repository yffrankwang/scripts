#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
# This script will set subversion property recursively
#
# Usage: SvnSetProp PROPNAME PROPVAL [PATH]

import fnmatch
import getopt
import os
import subprocess
import sys


class SvnSetProp:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.path = '.'
		self.propname = ''
		self.propval = ''
		self.includes = []
		self.excludes = []
		self.setdir = True
		self.setfile = True
		self.recu = False
		self.test = False

	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "SvnSetProp.py [Options] PROPNAME PROPVAL [PATH]"
		print 
		print "Options (takes an parameter):"
		print " -i, --include   Include files (wildcard)"
		print " -e, --exclude   Exclude files (wildcard)"
		print 
		print "Flags (no parameter):"
		print " -d, --dir       Set property to directory only"
		print " -f, --file      Set property to file only"
		print " -r, --recu      Recursively rename files in subdirectories"
		print " -t, --test      Test only" 
		print 
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?i:e:dfrt", 
				[ "help", "include=", "exclude=", "dir", "file", "recu", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--include", "-i"):
					self.includes.append(arg)
				elif opt in ("--exclude", "-e"):
					self.excludes.append(arg)
				elif opt in ("--dir", "-d"):
					self.setdir = True
					self.setfile = False
				elif opt in ("--file", "-f"):
					self.setdir = False
					self.setfile = True
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if len(args) < 1:
			self.showUsage("Missing PROPNAME argument!")
		self.propname = args[0]

		if len(args) < 2:
			self.showUsage("Missing PROPVAL argument!")
		self.propval  = args[1]

		if len(args) > 2:
			self.path = args[2]

	def run(self):
		print 'SvnSetProp %s=%s [ %s ]' % (self.propname, self.propval, self.path)
		if self.includes:
			print '  includes: %s' % (self.includes)
		if self.excludes:
			print '  excludes: %s' % (self.excludes)

		self.process(self.path)
		print 'OK!'

	def myexec(self, kargs, show):
		if show: print ' '.join(kargs)
		return subprocess.Popen(kargs, stdout=subprocess.PIPE).communicate()[0]

	def svnsetprop(self, path):
		if not self.setdir and os.path.isdir(path):
			return
		
		if not self.setfile and os.path.isfile(path):
			return
		
		fname = os.path.basename(path)
		if self.excludes:
			for p in self.excludes:
				if fnmatch.fnmatch(fname, p):
					return

		if self.includes:
			inc = False
			for p in self.includes:
				if not fnmatch.fnmatch(fname, p):
					inc = True
					break
			if not inc:
				return

		self.myexec(['svn', 'ps', self.propname, self.propval, path], True)
		
	def process(self, path):
		if not os.path.exists(path): 
			return

		self.svnsetprop(path)
	
		if self.recu and os.path.isdir(path):
			for subdir in os.listdir(path):
				if subdir == '.svn': continue
				npath = os.path.join(path, subdir)
				self.process(npath)

	
# start
if __name__ == "__main__":
	scp = SvnSetProp()
	
	scp.getArgs(sys.argv[1:])
	scp.run()

	sys.exit(0)
