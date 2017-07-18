import ijson
import json
import csv
from datetime import datetime
import sys
import codecs
import os


inputfile=sys.argv[1]
head,tail = os.path.split(inputfile)

print(head)
print(tail)
reader = csv.reader(open(inputfile, 'r'))
newfile=head+'/'+'new' + tail
tail = tail.split('.')
writer = csv.writer(open(newfile, 'w'))
for row in reader:
	row.append(tail[0])
	row.append('')
	row.append('')
	writer.writerow(row)


