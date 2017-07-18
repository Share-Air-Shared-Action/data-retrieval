import ijson
import json
import csv
from datetime import datetime
import sys
import io

inputfile=sys.argv[1]
filename2=inputfile+'.csv'
b=[]
with io.open(inputfile,encoding='windows-1252') as data_file:
    parser=ijson.parse(data_file)
    c=[]
    for prefix, event, value in parser:
    #    print(prefix,event,value)
        try:
            if (prefix, event) == ('results.item.Label', 'string'):
                b.append(c)
                c=[]
                #val = unicode(val, errors='replace')
                val=value;
                #print(val)
                c.append(val)
            elif (prefix, event) == ('results.item.Lat', 'string'):
                #print(val)
                val=float(value)
                c.append(val)
            elif (prefix, event) == ('results.item.Lon', 'string'):
                #print(val)
                val = float(value)
                c.append(val)

        except:
            print('its ok')
    print(b)


with open(filename2, 'w') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
    header = ["unit_id", "latitude", "longitude", "address", "dateinstalled", "community", "dateuninstalled"]
    writer.writerow(header)
    del b[0]
    for r in b:
        dname=r[0]
        print(dname)
        if(dname[:7] == "SASA_PA"):
            r.append('')
            r.append('')
            r.append('')
            r.append('')
            writer.writerow(r)

