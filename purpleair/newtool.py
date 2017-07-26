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
