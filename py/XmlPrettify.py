#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#

import codecs
import fnmatch
import getopt
import os
import sys
import xmlpp

class XmlPrettify:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.encoding = 'UTF-8'
		self.srcdir = '.'
		self.outdir = ''
		self.recu = False
		self.test = False
		self.bom = False


	def showUsage(self, err=None, exitCode=2):
		if err:
			print "Error:", err
			print
		print "XmlPrettify.py [Options] file1 file2 ..."
		print "Options (takes an parameter):"
		print " -s, --srcdir    Source Directory (default: %s)" % self.srcdir
		print " -o, --outdir    Output Directory (default: %s)" % self.outdir
		print " -e, --encoding  Source Encoding (default: %s)" % self.encoding
		print
		print "Flags (no parameter):"
		print " -r, --recu      Recursively prettify files in subdirectores"
		print " -t, --test      Test only (do not prettify the file)" 
		print

		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:o:e:rt",
				[ "help", "srcdir=", "outdir=", "encoding=", "recu", "test" ]
				)

			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--srcdir", "-s"):
					self.srcdir = arg
				elif opt in ("--outdir", "-o"):
					self.outdir = arg
				elif opt in ("--encoding", "-e"):
					self.encoding = arg
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)

		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if not self.outdir:
			self.outdir = self.srcdir

		self.files = args
		if not self.files:
			self.files = [ '*.xml' ]

	def run(self):
		print 'XmlPrettify %s(%s) %s -> %s' % (self.files, self.encoding, self.srcdir, self.outdir)
		self.process(self.srcdir, self.outdir)
		print 'OK!'

	def process(self, srcdir, outdir):
		for fn in os.listdir(srcdir):
			if fn[0] == '.':
				continue
			
			if os.path.isdir(os.path.join(srcdir, fn)):
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					ndes = os.path.join(outdir, fn)
					self.process(nsrc, ndes)
			else:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						self.prettify(srcdir, outdir, fn)

	def prettify(self, srcdir, outdir, fn):
		sf = os.path.join(srcdir, fn)
		if self.test:
			print "Testing: %s" % sf
			return

		tf = sf
		if srcdir == outdir:
			print "Prettifying xml: %s" % sf
		else:
			tf = os.path.join(outdir, fn)
			if not os.path.exists(outdir):
				os.makedirs(outdir)
			print "Prettifying xml: %s -> %s" % (sf, tf)

		# read source
		f = codecs.open(sf, 'rb', self.encoding)
		s = f.read()
		f.close()

		# prettify
		t = xmlpp.get_pprint(s, 2, 200)

		# write target
		f = codecs.open(tf, 'wb', self.encoding)
		if self.bom:
			f.write(codecs.BOM_UTF8)
		f.write(t)
		f.close()

# start
if __name__ == "__main__":
	ec = XmlPrettify()

	ec.getArgs(sys.argv[1:])
	ec.run()

	sys.exit(0)
