# This file processes the CSV to add columns before import.
import csv
import sys
import os

# Get the input file from the arguments
inputfile=sys.argv[1]

# Open the input file
reader = csv.reader(open(inputfile, 'r'))

# Get the input filename, split it
head,tail = os.path.split(inputfile)
print(head)
print(tail)

# Set the filename for the new file (append new at the beginning)
newfile=head+'/'+'new' + tail

# Isolate the device name
tail = tail.split('.')

writer = csv.writer(open(newfile, 'w'))
for row in reader:
	# Add the device_name column
	row.append(tail[0])

	# Add the season column
	row.append('')

	# Add the error column
	row.append('')

	# Write the row to the file
	writer.writerow(row)
