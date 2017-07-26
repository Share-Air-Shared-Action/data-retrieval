# This file processes the converted CSV to change data types and add columns before import.

import glob
import csv
import sys
import time
import datetime
import os

# For the filename provided
for filename in glob.glob(sys.argv[1]):
    data = []

    # Open the file
    with open(filename) as finput:
        # Unsure exactly what this was for, but it was commented out:
        #a,b=filename.split(".")

        # Get the part of the filename that is the device id.
        head,tail = os.path.split(filename)
        newfile=tail.split('.')

        # Convert the device id to an integer
        a=int(newfile[0])

        # For each row in the CSV
        for i, row in enumerate(csv.reader(finput)):

            # Set the variable "to_device" on first row to the header name, "device", following rows the device id.

            to_device = "device" if i == 0 else a

            # If not the first row of the CSV
            if i>0:

                # Do some formatting to get the date/time as needed
                t = int(row[2])
                t=t/1000

                # Set the row to the formatted date/time
                row[2]=datetime.datetime.fromtimestamp(t).strftime('%Y-%m-%d %H:%M:%S')

                # Append the name of the device to the row based on the device id
                # TODO: Hard-coded currently. Need to fix that.
                if(to_device==12396):
                    row.append("SASA_MO1")
                elif(to_device==12397):
                    row.append("SASA_MO2")
                elif(to_device==12398):
                    row.append("SASA_MO3")

                # Append the device ID to the row
                row.append(to_device)

                # Append the season, error check column, and community (blank for now as these are set in triggers.sql)
                row.append('')
                row.append(0)
                row.append('')

                # Appends the row to the data
                data.append(row)

    # Write the data back to the CSV.
    with open(filename,'wb') as foutput:
        writer = csv.writer(foutput)
        for row in data:
            writer.writerow(row)
