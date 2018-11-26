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
import exifread
import threading

# file extensions that will be uploaded (compared as lower case)
ALLOWED_EXT = set('''
jpeg
jpg
gif
png
'''.split())

DT1970 = datetime.datetime.fromtimestamp(0)

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

class PhotoDateThread(threading.Thread):
	def __init__(self, pds):
		threading.Thread.__init__(self)
		self.pds = pds

	def run(self):
		self.pds.run()

class PhotoDateSet:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.srcdir = '.'
		self.recu = False
		self.execu = False
		self.quiet = False
		self.abandon = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error:" + err)
			print("")
		print("PhotoDate.py [Options] file1 file2 ...")
		print("")
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print("")
		print("Flags (no parameter):")
		print(" -r, --recu      Recursively scan files in subdirectores")
		print(" -e, --exec      Set file's modify date from EXIF without prompt")
		print(" -q, --quiet     Do not show prompt")
		print("")
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:req", 
				[ "help", "src=", "recu", "exec", "quiet" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--recu", "-r"):
					self.recu = True
				elif opt in ("--exec", "-e"):
					self.execu = True
				elif opt in ("--quiet", "-q"):
					self.quiet = True
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

	def run(self):
		print('PhotoDate %s' % (self.srcdir))
		if self.execu:
			self.process(self.srcdir)
			return

		n = self.process(self.srcdir)
		if n == 0 or self.quiet:
			return

		a = raw_input("Are you sure to change date of %d files? (Y/N): " % n)
		if a.lower() == "y":
			self.execu = True
			self.process(self.srcdir)


	def process(self, srcdir):
		if self.abandon:
			return 0

		if not os.access(srcdir, os.W_OK):
			print(" [FAILED] No write access: %s" % srcdir)
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
					if self.touch(srcdir, fn):
						n += 1
		return n

	def touch(self, srcdir, sfn):
		sf = os.path.join(srcdir, sfn)

		idate = self.idate(sf)
		if idate is None:
			print(' [SKIP ] NO EXIF TAGS: %s' % sf)
			return False

		mdate = mtime(sf)
		diff = math.fabs(tseconds(mdate - idate))
		if diff > 2:
			sys.stdout.write(' [TOUCH] %s: %s -> %s ... ' % (sf, str(mdate), str(idate)))
			msg = '?'
			if self.execu:
				ft = ftime(idate)
				os.utime(sf, (ft, ft))
				msg = 'OK'
			print('[%s]' % msg)
			return True
		else:
			print(' [EQUAL] %s: %s %s %s' % (sf, str(mdate), "~=" if diff > 0 else "==", str(idate)))
			return False

	def idate(self, image):
		with open(image, 'rb') as f:
			try:
				exiftags = exifread.process_file(f)
			except:
				return None

		sdate = exiftags.get('Image DateTime')
		if sdate is None:
			sdate = exiftags.get('Image DateTimeOriginal')
		if sdate is None:
			sdate = exiftags.get('EXIF DateTimeOriginal')
		if sdate is None:
			sdate = exiftags.get('EXIF DateTimeDigitized')
		if sdate is None:
			return None
		
		try:
			return itime(sdate)
		except Exception, e:
			print(' [FAILED] Invalid EXIF Date of %s: %s' % (image, str(e)))
			return None

# start
if __name__ == "__main__":
	pds = PhotoDateSet()
	
	pds.getArgs(sys.argv[1:])

	thrd = PhotoDateThread(pds)
	thrd.start()
	
	while thrd.isAlive():
		try:
			thrd.join(0.05)
		except KeyboardInterrupt:
			print('>>>>>> Keyboard interrupt seen, stopping process ...')
			pds.abandon = True

	sys.exit(0)
