# This file processes a JSON file to return a list of needed values for Purple Air devices

import json, urllib
from subprocess import call

# Set the URL of the JSON file
url = 'https://map.purpleair.org/json'

# Get the JSON from the URL
response = urllib.urlopen(url).read()

# Their API is encoded in iso-8859-1. We must convert this to utf8 for JSON to parse.
decoded_response = response.decode('iso-8859-1').encode('utf8')

# Parse the JSON
data = json.loads(decoded_response)

# Open and clear the pgloader file
pgloaderfile = open("/data/sasa_airquality/purpleair/downloads/pgloaderfile.load","w")

# For each "result" in the JSON
for result in data['results']:
    # If the label starts with SASA
    if (result['Label'].startswith("SASA")):

        thingspeak_id = result['THINGSPEAK_PRIMARY_ID']
        thingspeak_apikey = result['THINGSPEAK_PRIMARY_ID_READ_KEY']

        # Removing spaces from label, as it messes up name otherwise.
        outputfilename = result['Label'].replace(" ","")

        # Call the shell script to download the data
        call(["sh", "/data/sasa_airquality/purpleair/curltool.sh", thingspeak_id, thingspeak_apikey, outputfilename])

        # Write a section of the pgloader file for this item
        pgloaderfile.write("LOAD CSV\n    FROM 'new" + outputfilename + ".csv' WITH ENCODING iso-646-us\n    INTO postgresql://postgres@localhost:5432/sasa_airquality?purpleairprimary\n    WITH  skip header = 2,\n        fields optionally enclosed by '\"',\n        fields escaped by backslash-quote,\n        fields terminated by ','\n\n    SET work_mem to '32 MB', maintenance_work_mem to '64 MB';\n\n")

# Close the pgloaderfile
pgloaderfile.close()
