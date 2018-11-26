#!/usr/bin/python
# -*- coding: UTF-8 -*-
#

import smtplib
import os
import sys
import getopt

class SendMail:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.host = 'localhost'
		self.port = 0
		self.ssl = False
		self.user = ''
		self.password = ''
		self.fromaddr = ''
		self.toaddrs = []
		self.subject = ''
		self.message = ''


	def showUsage(self, err = None, exitCode = 2):
		if err:
			print "Error:", err
			print
		print "SendMail.py [Options] message"
		print 
		print "Options (takes an parameter):"
		print " -h, --host     SMTP Server"
		print " -p, --port     SMTP Port"
		print "     --ssl      SMTP SSL Transport"
		print " -f, --from     From Address"
		print " -t, --to       To Address"
		print " -s, --subject  Mail Subject"
		print " -m, --message  Mail Message File"
		print 
		print 
		
		if exitCode > 0:
			sys.exit(exitCode)

	def getArgs(self, args):
		try:
			opts, args = getopt.getopt(args, "?h:p:f:u:w:t:s:m", 
				[ "help", "host=", "port=", "from=", "user=", "password=", "to=", "subject=", "message=", "ssl" ]
				)
	
			for opt, arg in opts:
				if opt in ("-?", "--help"):
					self.showUsage()
				elif opt in ("--host", "-h"):
					self.host = arg
				elif opt in ("--port", "-p"):
					self.port = int(arg)
				elif opt == "--ssl":
					self.ssl = True
				elif opt in ("--user", "-u"):
					self.user = arg
				elif opt in ("--password", "-w"):
					self.password = arg
				elif opt in ("--from", "-f"):
					self.fromaddr = arg
				elif opt in ("--to", "-t"):
					self.toaddrs.append(arg)
				elif opt in ("--subject", "-s"):
					self.subject = arg
				elif opt in ("--message", "-m"):
					with open(arg) as f:
						self.message = f.read()
				else:
					self.showUsage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.showUsage(str(e))

		if len(args) > 0:
			self.message = args[0]

		if not self.fromaddr:
			self.showUsage("From Address is Required!")

		if not self.toaddrs:
			self.showUsage("To Address is Required!")

	def run(self):
		print '------------------------------'
		print '  Server : %s %d' % (self.host, self.port)
		print '  From   : %s' % self.fromaddr
		print '  To     : %s' % ", ".join(self.toaddrs)
		print '  Subject: %s' % self.subject
		print '------------------------------'
		
		self.sendmail()
		print '>> OK!'

	def sendmail(self):
		raw = ("From: %s\r\nTo: %s\r\n\r\n%s" % (self.fromaddr, ", ".join(self.toaddrs), self.message))
		server = None
		if self.ssl:
			server = smtplib.SMTP_SSL(self.host, self.port)
		else:
			server = smtplib.SMTP(self.host, self.port)
		server.set_debuglevel(1)
#		server.starttls()
		if self.password:
			if not self.user:
				self.user = self.fromaddr
			server.login(self.user, self.fromaddr)
		server.sendmail(self.fromaddr, self.toaddrs, raw)
		server.quit()

	
# start
if __name__ == "__main__":
	sm = SendMail()
	
	sm.getArgs(sys.argv[1:])
	sm.run()

	sys.exit(0)
