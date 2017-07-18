import glob
import csv
import sys
import time
import datetime

for filename in glob.glob(sys.argv[1]):
    data = []
    outname=filename.split('_')
    outname[1]=outname[1]+".csv"
    with open(filename) as finput:
        	for i, row in enumerate(csv.reader(finput)):
	        	row.append('')
                	row.append('')
                	row.append('')
			data.append(row)
    with open(outname[1],'wb') as foutput:
        writer = csv.writer(foutput)
        for row in data:
            writer.writerow(row)
            
    
