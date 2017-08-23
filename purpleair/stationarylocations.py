# This file queries the PurpleAir API and adds any new sensors (along with their lat/lon) to the stationarylocations table

import json, urllib, sys, os, psycopg2
from datetime import datetime
import keys

# Open a log file
f = open("/data/sasa_airquality/purpleair/logs/stationarylocations.log", "a+")

# Create a function for logging/displaying output
def debugMessage(message):
    debugTime = str(datetime.now())
    print("[" + debugTime + "] " + message)
    f.write("[" + debugTime + "] " + message + "\n")
    f.flush()
    os.fsync(f.fileno())

# Set the URL of the JSON file
url = 'https://map.purpleair.org/json'

debugMessage("Starting stationarylocations.py with request URL: '" + url + "' and database: '" + keys.database + "'")

# Get the JSON from the URL
response = urllib.urlopen(url).read()

# Their API is encoded in iso-8859-1. We must convert this to utf8 for JSON to parse.
decoded_response = response.decode('iso-8859-1').encode('utf8')

# Parse the JSON
data = json.loads(decoded_response)

# For each "result" in the JSON
for result in data['results']:
    # If the label starts with SASA (or varied capitalization of it)
    if (result['Label'].upper().startswith("SASA")):
        sensorname = result['Label'].replace(" ","")
        lat = result['Lat']
        lon = result['Lon']
        community = ''
        if (len(sensorname) >= 10):
            community = sensorname[9] + sensorname [10]

        debugMessage("Entering sensor '" + sensorname + "' with lat: " + lat + " and with long: " + lon + " and with community " + community)

        try:
            dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
            dbConnection.autocommit = True

        except:
            debugMessage("Error connecting to database...")

            sys.exit(-1)

        try:
            dbCursor = dbConnection.cursor()

            dbCursor.execute("""INSERT INTO stationarylocations (unit_id, latitude, longitude, community)
                             VALUES (%s, %s, %s, %s)""",(sensorname, lat, lon, community))

        except psycopg2.Error as e:
            # No need to log duplicity errors
            if ("23505" not in e.pgcode):
                debugMessage("An error occurred entering data into database. Details: '" + e.pgerror + "'")
            else:
                debugMessage("Sensor '" + sensorname + "' already in database.")
