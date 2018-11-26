#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
# This script will copy all subversion properties from one source tree
# to another identical source tree. 
#
# Usage: SvnCopyProps SRC DST

import getopt
import os
import re
import subprocess
import sys
import tempfile


class SvnCopyProps:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = ''
		self.desdir = ''
		self.includes = []
		self.excludes = []
		self.test = False

	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "SvnCopyProps.py [Options] srcdir desdir"
		print 
		print "Options (takes an parameter):"
		print " -i, --include   Include properties (regex expression)"
		print " -e, --exclude   Exclude properties (regex expression)"
		print 
		print "Flags (no parameter):"
		print " -t, --test      Test only" 
		print 
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?i:e:t", 
				[ "help", "include=", "exclude=", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--include", "-i"):
					self.includes.append(re.compile(arg))
				elif opt in ("--exclude", "-e"):
					self.excludes.append(re.compile(arg))
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

	def fsstr(self, rs):
		fs = []
		for r in rs:
			fs.append(r.pattern)
		return fs

	def run(self):
		print 'SvnCopyProps %s -> %s' % (self.srcdir, self.desdir)
		if self.includes:
			print '  includes: %s' % self.fsstr(self.includes)
		if self.excludes:
			print '  excludes: %s' % self.fsstr(self.excludes)

		mytemp = tempfile.NamedTemporaryFile(delete=False)
		self.mytempfile = mytemp.name
		mytemp.close()
		
		self.process(self.srcdir, self.desdir)
		
		os.remove(self.mytempfile)
		print 'OK!'

	def myexec(self, kargs, show):
		if show: print ' '.join(kargs)
		return subprocess.Popen(kargs, stdout=subprocess.PIPE).communicate()[0]

	def svncopyprop(self, pname, src, dst):
		if self.excludes:
			for p in self.excludes:
				if p.search(pname):
					return


		if self.includes:
			inc = False
			for p in self.includes:
				if p.search(pname):
					inc = True
					break
			if not inc:
				return

		out = self.myexec(['svn', 'pg', '--strict', pname, src], False)
		with file(self.mytempfile, 'wb') as f:
			f.write(out)
		self.myexec(['svn', 'ps', pname, dst, '--file', self.mytempfile], True)
		
	def svncopyprops(self, src, dst):
		out = self.myexec(['svn', 'pl', '-q', src], False)
		pnames = out.split()
		
		for pname in pnames:
			self.svncopyprop(pname, src, dst)

	def process(self, src, dst):
		if not os.path.exists(dst): 
			return

		self.svncopyprops(src, dst)
	
		if os.path.isdir(src): 
			for subdir in os.listdir(src):
				if subdir == '.svn': continue
				nsrc = os.path.join(src, subdir)
				ndst = os.path.join(dst, subdir)
				self.process(nsrc, ndst)

	
# start
if __name__ == "__main__":
	scp = SvnCopyProps()
	
	scp.getArgs(sys.argv[1:])
	scp.run()

	sys.exit(0)
