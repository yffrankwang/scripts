#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#
	
import codecs
import fnmatch
import getopt
import os
import sys

class EncodingConverter:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcenc = ''
		self.desenc = 'UTF-8'
		self.srcdir = '.'
		self.outdir = ''
		self.recu = False
		self.test = False


	def showUsage(self, err=None, exitCode=2):
		if err:
			print("Error: " + err)
			print("")
		print("FileEncode.py [Options] file1 file2 ...")
		print("Options (takes an parameter):")
		print(" -s, --srcdir    Source Directory (default: %s)" % self.srcdir )
		print(" -o, --outdir    Output Directory (default: srcdir)")
		print(" -e, --srcenc    Source Encoding")
		print(" -d, --desenc    Target Encoding (default: %s)" % self.desenc)
		print()
		print("Flags (no parameter):")
		print(" -r, --recu      Recursively erase files in subdirectores")
		print(" -t, --test      Test only (do not erase the file)")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:o:e:d:rt",
				[ "help", "srcdir=", "outdir=", "srcenc=", "desenc=", "recu", "test" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--srcdir", "-s"):
					self.srcdir = arg
				elif opt in ("--outdir", "-o"):
					self.outdir = arg
				elif opt in ("--srcenc", "-e"):
					self.srcenc = arg
				elif opt in ("--desenc", "-d"):
					self.desenc = arg
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--test", "-t"):
					self.test = True
				else:
					self.showUsage("Invalid argument: " + opt)
						
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if not self.srcenc:
			self.showUsage();

		if not self.outdir:
			self.outdir = self.srcdir

		self.files = args
		if not self.files:
			self.files = [ '*.txt' ]

	def run(self):
		print('FileEncode %s (%s)%s -> (%s)%s' % (self.files, self.srcenc, self.srcdir, self.desenc, self.outdir))
		self.process(self.srcdir, self.outdir)
		print('OK!')

	def process(self, srcdir, outdir):
		for fn in os.listdir(srcdir):
			if fn[0] == '.':
				continue
			
			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					ndes = os.path.join(outdir, fn)
					self.process(nsrc, ndes)
			else:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						self.convert(srcdir, outdir, fn)

	def convert(self, srcdir, outdir, fn):
		sf = os.path.join(srcdir, fn)
		if self.test:
			print("Testing: %s (%s) -> (%s)" % (sf, self.srcenc, self.desenc))
			return

		tf = sf
	
		if srcdir == outdir:
			print("Encoding file: %s (%s) -> (%s)" % (sf, self.srcenc, self.desenc))
		else:
			tf = os.path.join(outdir, fn)
			if not os.path.exists(outdir):
				os.makedirs(outdir)
			print("Encoding file: %s (%s) -> %s (%s)" % (sf, self.srcenc, tf, self.desenc))

		# read source
		f = codecs.open(sf, 'rb', self.srcenc)
		s = f.read()
		f.close()

		# write target
		f = codecs.open(tf, 'wb', self.desenc)
		f.write(s)
		f.close()

# start
if __name__ == "__main__":
	ec = EncodingConverter()
	
	ec.getArgs(sys.argv[1:])
	ec.run()

	sys.exit(0)
