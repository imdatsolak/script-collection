#!/usr/bin/env python3
# coding=utf-8

import sys
import getopt

"""
Checks whether there are items in <backup-list> that were deleted
from the <live-list>

Usually used to compare "Motion Pictures" from Live System to the
same folder on backup-system.
"""
try:
    options, arguments = getopt.getopt(sys.argv[1:], 'l:b:')
except getopt.GetoptError:
    print('Usage:')
    print('\t checkdel.py -l <live-list> -b <backup-list>')
    sys.exit(2)

for opt, arg in options:
    if opt == '-l':
        livefile_name = arg
    elif opt == '-b':
        backupfile_name = arg

livefiles = []
backupfiles = []

livefile = open(livefile_name, 'r')
for line in livefile:
    line = line.strip()
    line = line.replace('*', '')
    livefiles.append(line)

livefile.close()
livefiles.sort()

backupfile = open(backupfile_name, 'r')
for line in backupfile:
    line = line.strip()
    line = line.replace('*', '')
    backupfiles.append(line)

backupfile.close()
backupfiles.sort()

for filename in backupfiles:
    filename = filename.replace('*', '')
    if not filename in livefiles:
        print('=>', filename.strip())

