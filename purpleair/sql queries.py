# I used this file to make the queries to add the SE locations to the stationarylocations table.
# TODO: Automate this so that it goes directly into database rather than just printing queries

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
        if ("SE" in result['Label']):

            # Removing spaces from label, as it messes up name otherwise.
            outputfilename = result['Label'].replace(" ","")

            lat = result['Lat']
            lon = result['Lon']

            print ("INSERT INTO stationarylocations(unit_id, latitude, longitude, community) VALUES ('" + outputfilename + "', " + lat + ", " + lon + ", 'SE');")
