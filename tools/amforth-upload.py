#!/usr/bin/env python

# amforth-upload.py
#
#   uploads text files containing forth commands to a microcontroller running amforth (v1.3)
#   monitors the output from the microcontroller and uses the character echo to implement a kind of software flow control
#   also waits for a prompt after each line to allow the compiler a chance to run
#
#   in theory it should never overrun the input buffer on the controller, 
#   but it will easily get stuck if the output from the controller is unusual
#
#   you have to kill any other processes that are accessing the serial port before running this,
#   otherwise it will miss characters that are stolen by the other process and get stuck
#
#   perhaps a better way to implement this would have been as a program that could be plugged into a terminal program
#   like x/y/zmodem for minicom (except for the difficulty of killing it when it gets confused). oh well.
#
#   mailto:pix@test.at
#   http://pix.test.at/


import sys
import getopt
import os
import re

def write_line_flow(string,dest):
	# strip comments
	# these probably will strip comment-like structures out of ." .." strings as well.

	if debug:
		print >>sys.stderr, "line before comment stripping: "+string

	string = re.sub("(^| )\( .*?\)"," ",string)
	string = re.sub("(^| )\( [^\)]*$"," \n",string)
	string = re.sub("(^| )\\\\ .*","",string)

	if re.match("^\s*$",string):
		if verbose:
			print >>sys.stderr, "skipping empty line"
		return	

	if debug:
		print >>sys.stderr, "line after comment stripping: "+string

	if verbose: 
		print >>sys.stderr, "sending line: "+string
	for o in list(string):
		dest.write(o);

		if o == "\t":
			o = " "
		
		while True:
			i = dest.read(1)
			#print "<"+i+"]",
			#print >>sys.stderr, "["+i+"]"
			sys.stdout.write(i)
			sys.stdout.flush()
			if i == o:
				#print "|",
				break	
	#dest.write("\n")
	if verbose:
		print >>sys.stderr, "waiting for prompt"

	start, nl, space, o, gt = range(5)

	state = start

	while True:
		#print >>sys.stderr, "{"+str(state)+"}"
		#dest.write("")
		i = dest.read(1)
		#print "<"+i+"]",
		#print >>sys.stderr, "["+i+"]"
		sys.stdout.write(i)
		sys.stdout.flush()
		if state == start:
			if i == "\r":
				state = nl
			elif i == " ":
				state = space
			continue
		elif state == nl:
			if i == ">":
				state = gt
			else:
				state = start
			continue
		elif state == gt:
			if i == " ":
				if debug:
					print >>sys.stderr, "<matched '^> '>"
				break
			else:
				state = start
			continue
		elif state == space:
			if i == "o":
				state = o
			else:
				state = start
			continue
		elif state == o:
			if i == "k":
				if debug:
					print >>sys.stderr, "<matched ' ok'>"
				break
			else:
				state = start
	
	


def write_file_flow(in_file,dest):
	while(True):
		line = in_file.readline()
		if len(line)>0:
			write_line_flow(line,dest)
		else:
			break		

def main(argv):

	global verbose, debug

	#in_file = file("file.frt")
	#tty_dev = file("/dev/ttyS0","w+",0)

	tty_dev_name = "/dev/ttyS0"
	force = False
	verbose = False
	debug = False

	try:
		opts, args = getopt.getopt(argv,"ht:vfd")
	except getopt.GetoptError:
		print >>sys.stderr, "unknown option. try -h"
		sys.exit(1)

	for opt, arg in opts:
		if opt == "-h":
			print >>sys.stderr, "usage: amforth-upload [-h] [-v] [-f] [-t tty] [file1] [file2] [...]"
			print >>sys.stderr, "\n   default tty is "+tty_dev_name
			print >>sys.stderr, "\n   if no files are specified, input is read from the the terminal"
			print >>sys.stderr, "\n   -f will run without checking for other processes accessing the tty"
			print >>sys.stderr, "\n   -v will print extra information during execution"
			sys.exit(1)
		elif opt == "-t":
			tty_dev_name = arg
		elif opt == "-v":
			verbose = True
		elif opt == "-f":
			force = True
		elif opt == "-d":
			debug = True

	if not force:	
		if not os.system("which fuser >/dev/null 2>&1"):
			if not os.system("fuser -u "+tty_dev_name):
				print >>sys.stderr, "the above process is accessing "+tty_dev_name+"."
				print >>sys.stderr, "please stop the process and try again."
				sys.exit(1)
		else:
			print >>sys.stderr, "couldn't find fuser. so i can't check if "+tty_dev_name+" is in use."
			print >>sys.stderr, "run with the -f option to force execution anyway"	


	tty_dev = file(tty_dev_name,"r+",0)

	if len(args)<1:
		if verbose:
			print >>sys.stderr, "processing stdin"
		write_file_flow(sys.stdin,tty_dev)
	else:
		for filename in args:
			in_file = file(filename,"r")
			if verbose:
				print >>sys.stderr, "processing "+filename
			write_file_flow(in_file,tty_dev)
			in_file.close()



if __name__ == "__main__":
	main(sys.argv[1:])