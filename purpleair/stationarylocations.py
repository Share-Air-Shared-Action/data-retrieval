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
url = 'https://map.purpleair.org/json?inc=246035%7C246037%7C246039%7C246041%7C246044%7C246046%7C246049%7C246051%7C246058%7C246060%7C246063%7C246065%7C246070%7C246072%7C246087%7C246089%7C246094%7C246096%7C246114%7C246116'

debugMessage("Starting stationarylocations.py with request URL: '" + url + "' and database: '" + keys.database + "'")

# Get the JSON from the URL
response = urllib.urlopen(url).read()

# Their API is encoded in iso-8859-1. We must convert this to utf8 for JSON to parse.
decoded_response = response.decode('iso-8859-1').encode('utf8')

# Parse the JSON
data = json.loads(decoded_response)

# For each "result" in the JSON
for result in data['results']:
    # First check that there is a label
    if (result['Label']):
        # If the label starts with SASA (or varied capitalization of it)
        if (result['Label'].upper().startswith("SASA")):
            # Replace any spaces and hyphens, then put in uppercase
            sensorname = result['Label'].replace(" ","").replace("-","_").upper()
            lat = result['Lat']
            lon = result['Lon']

            # Reset community
            community = ''

            # If size is correct to contain a community
            if (len(sensorname) >= 11):
                # Get the community from the 3rd spot between _
                community = sensorname.split("_")[2]

                # Make sure it is only two characters
                community = community[:2]

            debugMessage("Entering sensor '" + sensorname + "' with lat: " + str(lat) + " and with long: " + str(lon) + " and with community " + community)

            # Connect to the database using keys.py
            try:
                dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
                dbConnection.autocommit = True

            except:
                debugMessage("Error connecting to database...")
                sys.exit(-1)

            try:
                dbCursor = dbConnection.cursor()

                # Check to see if this Unit ID and community already exists
                dbCursor.execute("""SELECT unit_id FROM stationarylocations WHERE unit_id=%s AND community=%s""",(sensorname, community))

                # If the Unit ID and community already exists, update the lat/long
                if (dbCursor.fetchone() is not None):
                    dbCursor.execute("""UPDATE stationarylocations SET latitude=%s, longitude=%s WHERE unit_id=%s and community=%s""",(lat, lon, sensorname, community))

                # Otherwise add it
                else:
                    dbCursor.execute("""INSERT INTO stationarylocations (unit_id, latitude, longitude, community) VALUES (%s, %s, %s, %s)""",(sensorname, lat, lon, community))

            except psycopg2.Error as e:
                # No need to log the whole duplicity errors
                if ("23505" not in e.pgcode):
                    debugMessage("An error occurred entering data into database. Details: '" + e.pgerror + "'")
                else:
                    debugMessage("Sensor '" + sensorname + "' already in database.")
