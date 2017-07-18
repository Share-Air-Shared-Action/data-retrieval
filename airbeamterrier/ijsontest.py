import ijson
import json
import csv
from datetime import datetime
import sys

inputfile=sys.argv[1]
#filename=inputfile+'sensorinfo.csv'
filename2=inputfile+'.csv'
datameasure=[]
with open(inputfile) as data_file:
    parser= ijson.parse(data_file)
    ind=0
    d=[]
    b=[]
    c=[]
    streamvalue=""
    pkgname=""
    for prefix, event, value in parser:
#        if(ind<300):
#            print(prefix,event,value)
        if (prefix, event) == ('item.title', 'string'):
            c=[]
            val = value
            val=val.replace("\r","")
            val=val.replace("\n", "")
            print(val)
            c.append(val)
            #c.append('%s' % value)
        elif (prefix, event) == ('item.username', 'string'):
            c.append('%s' % value)
        elif (prefix, event) == ('item.streams', 'map_key'):
            #data.append(d)
            d=[]
            streamvalue=value
        elif prefix.endswith('.average_value'):
            d.append('%.2f' %value)
        elif prefix.endswith('.measurement_type'):
            d.append('%s' %value)
        elif prefix.endswith('.sensor_package_name'):
            d.append('%s' %value)
            pkgname=value
        elif prefix.endswith('.unit_name'):
            d.append('%s' %value)

        print(prefix, event)
        if (prefix, event) == ('item.streams.%s.measurements.item' %streamvalue, 'start_map'):
            datameasure.append(b)
            b=[]
            for j in c:
                b.append(j)
            for i in d:
                b.append(i)
            #b.append(pkgname)
        elif prefix.endswith('%s.measurements.item.latitude' %streamvalue):
            b.append('%s' %value)
        elif prefix.endswith('%s.measurements.item.longitude' %streamvalue):
            b.append('%s' %value)
        elif prefix.endswith('%s.measurements.item.measured_value' %streamvalue):
            b.append('%s' %value)
        elif prefix.endswith('%s.measurements.item.time' %streamvalue):
            dt=datetime.strptime(value, "%Y-%m-%dT%H:%M:%SZ")
            b.append(dt)
        ind=ind+1
        
with open(filename2, 'w') as csvfile2:
    writer = csv.writer(csvfile2, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    h2 = ["average_value", "measurement_type", "sensor_package_name", "unit_name", "latitude", "longitude", "measured_value", "time"]
    writer.writerow(h2)
    for r in datameasure:
      r.append('')
      r.append('')
      writer.writerow(r)

