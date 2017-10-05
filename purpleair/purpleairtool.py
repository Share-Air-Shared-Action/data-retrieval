# This file processes a JSON file to return a list of needed values for Purple Air devices
# TODO: Check previous days

import json, csv, urllib, sys, os, psycopg2, pytz
from datetime import datetime
import keys

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

# Connect to the database
try:
    dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
    dbConnection.autocommit = True
    dbCursor = dbConnection.cursor()

except:
    debugMessage("Error connecting to database...");
    sys.exit(-1)

# For each "result" in the JSON
for result in JSONdata['results']:
    # First, check that it has a label, otherwise it might fail here
    if (result['Label']):
        # Clean up the label and make uppercase
        fixed_label = upper(result['Label']).replace(" ","").replace("-","_");
        # If the label starts with SASA
        if (fixed_label).startswith("SASA")):

            thingspeak_id = result['THINGSPEAK_PRIMARY_ID']
            thingspeak_apikey = result['THINGSPEAK_PRIMARY_ID_READ_KEY']

            # Reset community
            community = ''

            # If size is correct to contain a community
            if (len(sensorname) >= 10):
                # Get the community from the 3rd spot between _
                community = sensorname.split("_")[2]

            #TODO: Check what days have executed (use a database call?) and look at any other days (past an initial date?). Once a day has been looked at, mark it as looked at somehow (another database call?) and use this to set the start_date and end_date for below

            # The day to look at
            start_date = ''

            # The next day (not inclusive)
            end_date = ''

            CSVurl = "https://thingspeak.com/channels/" + thingspeak_id + "/feed.csv?api_key=" + thingspeak_apikey + "&offset=0&average=&round=2&start=" + start_date + "&end=" + end_date + "&timezone=" + timezone

            CSVresponse = urllib.urlopen(CSVurl).read()

            CSVdata = csv.reader(CSVresponse, delimiter=',')

            # Skip the header by using this variable
            checkedHeader = False

            # For each row in the CSV
            for row in CSVdata:

                # Convert time string to datetime object (format in CSV: "2017-08-02 23:34:45 UTC"):
                time = datetime.strptime(row[0], '%Y-%m-%d %H:%M:%S UTC')

                # Set timezone on object (set via offset parameter, we are using UTC in request)
                UTC = pytz.timezone('UTC')
                time = UTC.localize(time)

                # Adjust datetime to Chicago timezone
                time = time.astimezone(pytz.timezone("America/Chicago"))

                if (checkedHeader is True):
                    # This should be all the rows past the header.
                    #TODO: Enter the data into the database here
                    dbCursor.execute("INSERT INTO purpleairprimary (created_at, entry_id, pm1_cf_atm_ugm3, pm25_cf_atm_ugm3, pm10_cf_atm_ugm3, uptimeminutes, rssi_dbm, temperature_f, humidity_percent, pm25_cf_1_ugm3, device_name, community) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9], fixed_label, community)


                # Skip the header
                else:
                    checkedHeader = True
