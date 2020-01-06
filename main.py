#!/usr/bin/env python

# BSD 3-Clause License

# Copyright (c) 2019, Fabricio Rodriguez, UNICAMP, Brazil
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.

# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import os
import re
import string
import sys
import random
import socket
from random import shuffle
import argparse
from argparse import ArgumentParser
from subprocess import call
import collections
import time
#from lib.test_2 import *

def main(delay_ms):
    
	#parser = ArgumentParser(description='Robot + P4', formatter_class=SmartFormatter)

	#parser.add_argument('-t','--time', metavar='',
	#			help="R|Delay:\n",
	#			dest='delay', action="store", type=float, default='0')

	#args = parser.parse_args()

	delay = float(delay_ms)

	HOST = "192.168.10.3"    # The remote host
	PORT = 30000              # The same port as used by the server
	
	count = 0
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)


	s.bind((HOST, PORT)) # Bind to the port 
	s.listen(5) # Now wait for client connection.	

	c, addr = s.accept()
	print ("Starting RX")
	print ("Delay ", delay)
	val=0
	val1=0
	while (count < 1000):
		try:
		   msg = c.recv(1024)
		   #print ("Pose Position = ", val,msg)
		   #print (datetime.now().strftime("%H:%M:%S.%f"))
		   #print ("Pose Position = ", val,msg)
		   msg2 = msg.split(",")
		   msg3 = msg2[0].split("[")
	   	   msg4=list(msg3[1])
  	   	   #print(msg3[1])
		   msg5=float(msg3[1])
  	   	   #print(msg5)
		   #print ("MATCH len ", len(msg4))
	 	   val=val+1
		   #print ("Pose Position = ", val,msg)
		   if msg5 >= 1.88:
		   #if 0 <= 5 <= len(msg4):
	  	   #	if  msg4[0] == "1":
		   #		if msg4[2] == "8":
		   #			print(msg4)
		   #			if int(msg4[3]) > 7:
						#if msg4[4] == "4" or msg4[4] == "5":
		   	print(msg5)
		   	print("------YES_______")
	  	   	time.sleep(delay)
		   	c.send("(0)");
		   	val1=1
		   if val1 == 1:
			print ("Pose Position = ", val,msg)
			val1 = 0
			s.close()
			c.close()
				#count = 1000
				
		except socket.error as socketerror:
		   count = count + 1

	s.close()
	c.close()


	print ("Program finish")


delay = [0,0.005,0.01,0.015,0.025,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5]
print delay
val = 0 
for val in range(0,len(delay)):
	main(delay[val])
