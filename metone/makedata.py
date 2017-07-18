import glob
import csv
import sys
import time
import datetime
import os
for filename in glob.glob(sys.argv[1]):
    data = []
    with open(filename) as finput:
        #a,b=filename.split(".")
	print(filename)
	head,tail = os.path.split(filename)
	newfile=tail.split('.')
        a=int(newfile[0])
	print(a)
        for i, row in enumerate(csv.reader(finput)):
            to_device = "device" if i == 0 else a
            if i>0:
	      t = int(row[2])
	      t=t/1000
              row[2]=datetime.datetime.fromtimestamp(t).strftime('%Y-%m-%d %H:%M:%S')

            if(to_device==12396):
                row.append("SASA_MO1")
            elif(to_device==12397):
                row.append("SASA_MO2")
            elif(to_device==12398):
                row.append("SASA_MO3")
	    row.append(to_device)  
	    row.append('')
	    row.append(0)

            data.append(row)

    with open(filename,'wb') as foutput:
        writer = csv.writer(foutput)
        for row in data:
            writer.writerow(row)
            
    
