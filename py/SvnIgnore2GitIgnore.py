#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
# This script will convert svn:ignore properties to .gitignore file.
#
# Usage: SvnIgnore2GitIgnore DIR

import getopt
import os
import subprocess
import sys


class SvnIgnore2GitIgnore:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = '.'
		self.recu = False
		self.test = False

	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print()
		print("SvnIgnore2GitIgnore.py [srcdir]")
		print()
		print("Flags (no parameter):")
		print " -r, --recu      Recursively into subdirectories"
		print(" -t, --test      Test only")
		print()
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?rt", 
				[ "help", "recu", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if len(args) > 0:
			self.srcdir = args[0]

	def run(self):
		self.process(self.srcdir)

	def myexec(self, kargs, show):
		if show:
			print(' '.join(kargs))
			
		return subprocess.Popen(kargs, stdout=subprocess.PIPE).communicate()[0]

	def svnignore2gitignore(self, src):
		if not os.path.exists(os.path.join(src, '.svn')):
			return

		sys.stdout.write(('> ' + src + ' ').ljust(60, '.') + ' ')
		out = self.myexec(['svn', 'pg', 'svn:ignore', src], False)
		signores = out.split()
		
		gignores = []
		if os.path.exists(os.path.join(src, '.gitignore')):
			with open(os.path.join(src, '.gitignore')) as f:
				for s in f:
					s = s.strip()
					if s:
						gignores.append(s)

		skip = True
		for si in signores:
			gi = '/' + si
			if not gi in gignores:
				gignores.append(gi)
				skip = False

		if skip:
			print('SKIP')
			return
		
		if gignores:
			with open(os.path.join(src, '.gitignore'), 'wb') as f:
				for gi in gignores:
					f.write(gi + '\n')
			print('OK')
		else:
			if os.path.exists(os.path.join(src, '.gitignore')):
				os.remove(os.path.join(src, '.gitignore'))
			print('DEL')

	def process(self, src):
		self.svnignore2gitignore(src)

		if self.recu and os.path.isdir(src):
			for subdir in os.listdir(src):
				if subdir in ['.svn', '.git']:
					continue
				nsrc = os.path.join(src, subdir)
				self.process(nsrc)


# start
if __name__ == "__main__":
	scp = SvnIgnore2GitIgnore()
	
	scp.getArgs(sys.argv[1:])
	scp.run()

	sys.exit(0)
