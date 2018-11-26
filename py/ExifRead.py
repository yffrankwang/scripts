#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import datetime
import math
import time
import fnmatch
import os
import sys
import getopt
import piexif
import threading
import unicodedata

SENC = sys.getdefaultencoding()
FENC = sys.getfilesystemencoding()
DT1970 = datetime.datetime.fromtimestamp(0)

# file extensions that will be uploaded (compared as lower case)
ALLOWED_EXT = set('''
jpeg
jpg
tiff
'''.split())


if sys.version_info >= (3, 0):
	def raw_input(s):
		return input(s)

def tseconds(td):
	return (td.seconds + td.days * 24 * 3600)

def mtime(p):
	return datetime.datetime.fromtimestamp(os.path.getmtime(p)).replace(microsecond=0)

def itime(s):
	return datetime.datetime.strptime(str(s), '%Y:%m:%d %H:%M:%S').replace(microsecond=0)
		
def ftime(dt):
	return tseconds(dt - DT1970)

def normpath(s):
	return unicode(s, FENC)

def uprint(s):
	try:
		print(s)
	except Exception:
		try:
			print(s.encode(SENC))
		except Exception:
			print(s.encode('utf-8'))


class ExifReadThread(threading.Thread):
	def __init__(self, er):
		threading.Thread.__init__(self)
		self.er = er

	def run(self):
		self.er.run()

class ExifRead:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = '.'
		self.recu = False
		self.none = False
		self.abandon = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print("")
		print("ExifRead.py [Options] file1 file2 ...")
		print("")
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print("")
		print("Flags (no parameter):")
		print(" -r, --recu      Recursively scan files in subdirectores")
		print(" -n, --none      Print file which Exif data does not exists")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:rn", 
				[ "help", "src=", "recu", "none" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--none", "-n"):
					self.none = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

	def run(self):
		print('ExifRead %s' % (self.srcdir))
		self.process(self.srcdir)


	def process(self, srcdir):
		if self.abandon:
			return 0

		if not os.access(srcdir, os.R_OK):
			print(" [FAILED] No READ access: %s" % normpath(srcdir))
			return 0
		
		n = 0
		for fn in os.listdir(srcdir):
			if self.abandon:
				break

			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					n += self.process(nsrc)
			else:
				ext = fn.lower().split(".")[-1]
				if ext in ALLOWED_EXT:
					if self.readexif(srcdir, fn):
						n += 1
		return n

	def readexif(self, srcdir, sfn):
		sf = os.path.join(srcdir, sfn)

		try:
			exif = piexif.load(sf).get('Exif')
		except:
			exif = None
			
		if exif:
			if self.none:
				return

			print(normpath(sf))
			for k,v in exif.iteritems():
				kd = piexif._exif.TAGS['Exif'].get(k)
				if kd:
					k = kd['name']
				print("  " + str((k, v)))
		else:
			if self.none:
				print('[%s] %s' % (str(mtime(sf)), normpath(sf)))


# start
if __name__ == "__main__":
	er = ExifRead()
	
	er.getArgs(sys.argv[1:])

	thrd = ExifReadThread(er)
	thrd.start()
	
	while thrd.isAlive():
		try:
			thrd.join(0.05)
		except KeyboardInterrupt:
			print('>>>>>> Keyboard interrupt seen, stopping process ...')
			er.abandon = True

	sys.exit(0)
