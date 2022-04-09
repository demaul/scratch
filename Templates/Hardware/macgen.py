#! /usr/bin/python
#
# macgen.py script generates a MAC address for Dell C6100 BMC controllers
# it runs a command that reprograms the IPMI / BMC mac address to a randomized mac address
# this is useful since the flash upgrade process for the BMC on the Dell C6100 will
# typically "zero out" the mac address, which causes serious problems and conflicts on the network
#
print " "
print "Created by and Copyright 2013 Input Output Flood, LLC"
print "www.IOFLOOD.com -- We Love Servers"
print " "
print "This script may be freely distributed"
print "so long as this copyright notice is not edited"
#
print " "
print "This script is provided with no warranty. Use at your own risk."
#
# This script has been tested as working on a Dell DCS C6100 using IPMI / BMC firmware versions 1.25 and 1.30.
# We have not tested any other versions, though we do expect it would work with other versions.
#
# This script requires "ipmitool" be installed. In centos you may install ipmitool with the following commands:
#
# yum -y install OpenIPMI OpenIPMI-devel OpenIPMI-libs OpenIPMI-tools kernel-devel gcc gcc-c++ make
#
# chkconfig ipmi on
# service ipmi start
#
# wget "http://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.11/ipmitool-1.8.11.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fipmitool%2Ffiles%2Fipmitool%2F1.8.9%2F&ts=1311648838&use_mirror=cdnetworks-us-2"
# tar -zxf ipmitool-1.8.11.tar.gz
# cd ipmitool-1.8.11
# ./configure && make && make install
#
# This script was tested with the BMC controller NIC set to "dedicated".
# The first command output will work for that setting.
# The second command output is expected to work when the NIC is set to "shared", but this has not been tested.
#
import random

# the first half of the mac address will always be 00:16:3e, because that's worked for us. If you want something random or something different, edit the next 6 lines:

mac1= "%1x" % random.randint(0x0, 0x0)
mac2= "%1x" % random.randint(0x0, 0x0)
mac3= "%1x" % random.randint(0x1, 0x1)
mac4= "%1x" % random.randint(0x6, 0x6)
mac5= "%1x" % random.randint(0x3, 0x3)
mac6= "%1x" % random.randint(0xe, 0xe)

# the second half of the mac address is random

mac7= "%1x" % random.randint(0x0, 0xf)
mac8= "%1x" % random.randint(0x0, 0xf)
mac9= "%1x" % random.randint(0x0, 0xf)
mac10= "%1x" % random.randint(0x0, 0xf)
mac11= "%1x" % random.randint(0x0, 0xf)
mac12= "%1x" % random.randint(0x0, 0xf)

print " "
print "Updating Dell C6100 BMC Mac address to: " + mac1 + mac2 + ':' + mac3 + mac4 + ':' + mac5 + mac6 + ':' + mac7 + mac8 + ":" + mac9 + mac10 + ":" + mac11 + mac12

mac1 = hex(ord(mac1))
mac2 = hex(ord(mac2))
mac3 = hex(ord(mac3))
mac4 = hex(ord(mac4))
mac5 = hex(ord(mac5))
mac6 = hex(ord(mac6))
mac7 = hex(ord(mac7))
mac8 = hex(ord(mac8))
mac9 = hex(ord(mac9))
mac10 = hex(ord(mac10))
mac11 = hex(ord(mac11))
mac12 = hex(ord(mac12))

executioner1 = 'ipmitool raw 0x2e 0x21 ' + mac1 + ' ' + mac2 + ' 0x3a ' + mac3 + ' ' + mac4 + ' 0x3a ' + mac5 + ' ' + mac6 + ' 0x3a ' + mac7 + ' ' + mac8 + ' 0x3a ' + mac9 + ' ' + mac10 + ' 0x3a ' + mac11 + ' ' + mac12 + ' 0x00'
executioner2 = 'ipmitool raw 0x2e 0x23 ' + mac1 + ' ' + mac2 + ' 0x3a ' + mac3 + ' ' + mac4 + ' 0x3a ' + mac5 + ' ' + mac6 + ' 0x3a ' + mac7 + ' ' + mac8 + ' 0x3a ' + mac9 + ' ' + mac10 + ' 0x3a ' + mac11 + ' ' + mac12 + ' 0x00'

import subprocess
import shlex
executioner1 = shlex.split(executioner1)
executioner2 = shlex.split(executioner2)
subprocess.call(executioner1)
subprocess.call(executioner2)

print "Update Complete. Restarting IPMI module"

reset = shlex.split("ipmitool mc reset cold")
subprocess.call(reset)
print " "
print "Wait 30 seconds, then run 'ipmitool lan print 1' to verify mac address"  