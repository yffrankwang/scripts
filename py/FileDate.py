#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import fnmatch
import os
import sys
import getopt
import datetime

DT1970 = datetime.datetime.fromtimestamp(0)

if os.name == 'nt':
	import win32con, win32file, pywintypes
	def setCreationTime(fname, newtime):
		wintime = datetime.datetime.utcfromtimestamp(newtime).replace(tzinfo=datetime.timezone.utc)
		winfile = win32file.CreateFile(
			fname, win32con.GENERIC_WRITE,
			win32con.FILE_SHARE_READ | win32con.FILE_SHARE_WRITE | win32con.FILE_SHARE_DELETE,
			None, win32con.OPEN_EXISTING,
			win32con.FILE_ATTRIBUTE_NORMAL, None)
		win32file.SetFileTime(winfile, wintime, None, None)
		winfile.close()

if sys.version_info >= (3, 0):
	def raw_input(s):
		return input(s)

def mtime(p):
	return datetime.datetime.fromtimestamp(os.path.getmtime(p)).replace(microsecond=0)

def ctime(p):
	return datetime.datetime.fromtimestamp(os.path.getctime(p)).replace(microsecond=0)

def itime(s, f):
	return datetime.datetime.strptime(str(s), f).replace(microsecond=0)
		
def ftime(dt):
	return tseconds(dt - DT1970)

def tseconds(td):
	return (td.seconds + td.days * 24 * 3600)


class FileDate:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.files = []
		self.srcdir = '.'
		self.mdate = ''
		self.cdate = ''
		self.format = "%Y%m%d.%H%M%S"
		self.dir = False
		self.recu = False
		self.execu = False
		self.quiet = False


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print("Error: "  + err)
			print('')
		print("FileDate.py [Options] file1 file2 ...")
		print('')
		print("Options (takes an parameter):")
		print(" -s, --src       Source Directory (default: %s)" % self.srcdir)
		print(" -c, --cdate     File creation date (%Y%m%d.%H%M%S)")
		print(" -m, --mdate     File modification date (%Y%m%d.%H%M%S)")
		print(" -f, --format    Date format (default: %s)" % self.format)
		print('')
		print("Flags (no parameter):")
		print(" -d, --dir       Modify directory date")
		print(" -r, --recu      Recursively change date of files in sub directories")
		print(" -e, --exec      Execute file date change without prompt")
		print(" -q, --quiet     Do not show prompt")
		print('')
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "h?s:m:c:f:dreq", 
				[ "help", "src=", "mdate=", "cdate=", "format=", "dir", "recu", "exec", "quiet" ]
				)
	
			for opt, arg in opts:
				if opt in ("-h", "-?", "--help"):
					self.showUsage()
				elif opt in ("--src", "-s"):
					self.srcdir = arg
				elif opt in ("--mdate", "-m"):
					self.mdate = arg
				elif opt in ("--cdate", "-c"):
					self.cdate = arg
				elif opt in ("--format", "-f"):
					self.format = arg
				elif opt in ("--dir", "-d"):
					self.dir = True
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

		self.files = args
		if not self.files:
			self.files = [ '*' ]

		if not self.cdate and not self.mdate:
			self.showUsage("Missing --mdate or --cdate argument!")


	def run(self):
		print('FileDate %s/%s (%s)' % (self.srcdir, self.files, self.mdate))
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
		if not os.access(srcdir, os.W_OK):
			return 0
		
		n = 0
		for fn in os.listdir(srcdir):
			ren = False
			if os.path.isdir(os.path.join(srcdir, fn)):
				if fn[0] == '.':
					continue
				if self.recu:
					nsrc = os.path.join(srcdir, fn)
					n += self.process(nsrc)
				ren = self.dir
			else:
				ren = not self.dir

			if ren:
				for p in self.files:
					if fnmatch.fnmatch(fn, p):
						self.touch(srcdir, fn)
						n += 1
		return n

	def touch(self, srcdir, sfn):
		sf = os.path.join(srcdir, sfn)

		ncdate = self.cdate
		if ncdate == 'now':
			ncdate = datetime.datetime.now().replace(microsecond=0)
		elif ncdate == 'mdate':
			ncdate = mtime(sf)
		elif ncdate[:4] == 'name':
			fn = os.path.splitext(sfn)[0]
			if len(ndate) > 4:
				fn = fn[:int(ndate[4:])]
			ncdate = itime(fn, self.format)
		elif ncdate:
			ncdate = itime(ncdate, self.format)

		nmdate = self.mdate
		if nmdate == 'now':
			nmdate = datetime.datetime.now().replace(microsecond=0)
		elif nmdate == 'cdate':
			nmdate = ctime(sf)
		elif nmdate[:4] == 'name':
			fn = os.path.splitext(sfn)[0]
			if len(ndate) > 4:
				fn = fn[:int(ndate[4:])]
			nmdate = itime(fn, self.format)
		elif nmdate:
			nmdate = itime(nmdate, self.format)

		omdate = None
		if nmdate:
			omdate = mtime(sf)
			if nmdate.hour == 0 and nmdate.minute == 0 and nmdate.second == 0 and nmdate.microsecond == 0:
				nmdate = nmdate.replace(hour=omdate.hour, minute=omdate.minute, second=omdate.second, microsecond=omdate.microsecond)

		ocdate = None
		if ncdate:
			ocdate = ctime(sf)
			if ncdate.hour == 0 and ncdate.minute == 0 and ncdate.second == 0 and ncdate.microsecond == 0:
				ncdate = ncdate.replace(hour=ocdate.hour, minute=ocdate.minute, second=ocdate.second, microsecond=ocdate.microsecond)

		sys.stdout.write(' [TOUCH] %s: %s %s -> %s %s ... ' % (sf, 
			str(ocdate) if ocdate else '', 
			str(omdate) if omdate else '', 
			str(ncdate) if ncdate else '', 
			str(nmdate) if nmdate else ''))
		msg = '?'
		if self.execu:
			if nmdate:
				ft = ftime(nmdate)
				os.utime(sf, (ft, ft))
			if ncdate:
				ft = ftime(ncdate)
				setCreationTime(sf, ft)
			msg = 'OK'
		print('[%s]' % msg)


# start
if __name__ == "__main__":
	fr = FileDate()
	
	fr.getArgs(sys.argv[1:])
	fr.run()

	sys.exit(0)
