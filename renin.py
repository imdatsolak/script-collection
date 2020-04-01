from __future__ import print_function
import sys
reload(sys)
import os
index = 10000000
for root, dirs, files in os.walk('.'):
    for filename in files:
        entries = filename.split('.')
        extension = entries[-1]
        newfilename = '{}'.format(index)
        newfilename += '.' + extension
        print('{} -> {}'.format(filename, newfilename))
        os.rename(filename, newfilename)
        index = index + 1
