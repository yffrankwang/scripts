#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
# pip install python-whois
#

import getopt
import sys
import whois

class PyWhois:
	def __init__(self):
		# ----------------------------
		# arguments
		# ----------------------------
		self.domains = []
		self.infile = None
		self.outfile = None

	def show_usage(self, err = None, exitCode = 2):
		if err:
			print("Error: %s" % err)
			print('')
		print("Whois.py [Options] domain1 domain2")
		print('')
		print("Options (takes an parameter):")
		print(" -i, --in      Input file")
		print(" -o, --out     Output file")
		print('')
		
		if exitCode > 0:
			sys.exit(exitCode)

	def get_args(self, args):
		try:
			opts, args = getopt.getopt(args, "?h:i:o", 
				[ "help", "in=", "out=" ]
				)
	
			for opt, arg in opts:
				if opt in ("-?", "--help"):
					self.show_usage()
				elif opt in ("--in", "-i"):
					self.infile = arg
				elif opt in ("--out", "-o"):
					self.outfile = arg
				else:
					self.show_usage("Invalid argument: " + opt)
		except getopt.GetoptError as e:
			self.show_usage(str(e))

		self.domains = args

		if len(self.domains) < 1 and not self.infile:
			self.show_usage("Missing [Input file] or arguments!")

	def run(self):
		if self.infile:
			# get domains from file
			with open(self.infile, 'rb') as f:
				self.domains.extend([line.rstrip() for line in f if line.rstrip()])

		domains = set(self.domains)
		for domain in domains:
			print('---------------------------------')
			print(domain)
			print('---------------------------------')
			record = whois.whois(domain)
			print(record.text)

# write each whois record to a file {domain}.txt
#with open("%s.txt" % domain, 'wb') as f:
#	f.write(record.text)
				
	
# start
if __name__ == "__main__":
	w = PyWhois()
	
	w.get_args(sys.argv[1:])
	w.run()

	sys.exit(0)

