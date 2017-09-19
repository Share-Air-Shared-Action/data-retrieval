# This file processes a JSON file to return a list of needed values for Purple Air devices
# TODO: Add the Lat/Long to the stationarylocations table, enter directly to database instead of pgloader.

import json, csv, urllib, sys, os, psycopg2, pytz
from datetime import datetime
import keys

# Timezone to fetch the data using
timezone = "America/Chicago"

# Open the log file
log = open("/data/sasa_airquality/airbeamterrier/logs/airbeamterrier.log", "a+")

# Create a function for logging/displaying output
def debugMessage(message):
    print(message)
    log.write(message + "\n")
    log.flush()
    os.fsync(log.fileno())

# Set the URL of the JSON file
JSONurl = 'https://map.purpleair.org/json'

# Set the download directory
downloadDirectory = '/data/sasa_airquality/purpleair/downloads/'

# Get the JSON from the URL
JSONresponse = urllib.urlopen(JSONurl).read()

# Their API is encoded in iso-8859-1. We must convert this to utf8 for JSON to parse.
decoded_response = JSONresponse.decode('iso-8859-1').encode('utf8')

# Parse the JSON
JSONdata = json.loads(decoded_response)

# For each "result" in the JSON
for result in JSONdata['results']:
    # If the label starts with SASA
    if (upper(result['Label']).startswith("SASA")):

        thingspeak_id = result['THINGSPEAK_PRIMARY_ID']
        thingspeak_apikey = result['THINGSPEAK_PRIMARY_ID_READ_KEY']

        #TODO: Check what days have executed (use a database call?) and look at any other days (past an initial date?). Once a day has been looked at, mark it as looked at somehow (another database call?) and use this to set the start_date and end_date

        CSVurl = "https://thingspeak.com/channels/" + thingspeak_id + "/feed.csv?api_key=" + thingspeak_apikey + "&offset=0&average=&round=2&start=" + start_date + "&end=" + end_date + "&timezone=" + timezone

        CSVresponse = urllib.urlopen(CSVurl).read()

        CSVdata = csv.reader(CSVresponse, delimiter=',')

        # Skip the header by using this variable
        checkedHeader = False

        # For each row in the CSV
        for row in parsedCSV:

            if (checkedHeader is True):
                # This should be all the rows past the header.
                #TODO: Enter the data into the database here


            # Skip the header
            else:
                checkedHeader = True


        # # Call the shell script to download the data
        # call(["sh", "/data/sasa_airquality/purpleair/curltool.sh", thingspeak_id, thingspeak_apikey, outputfilename])





        # # Write a section of the pgloader file for this item
        # pgloaderfile.write("LOAD CSV\n    FROM 'new" + outputfilename + ".csv' WITH ENCODING iso-646-us\n    INTO postgresql://postgres@localhost:5432/sasa_airquality?purpleairprimary\n    WITH  skip header = 2,\n        fields optionally enclosed by '\"',\n        fields escaped by backslash-quote,\n        fields terminated by ','\n\n    SET work_mem to '32 MB', maintenance_work_mem to '64 MB';\n\n")

# Close the pgloaderfile
pgloaderfile.close()
