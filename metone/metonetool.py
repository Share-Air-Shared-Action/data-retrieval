# This tool requests data from Metone's API and enters it into our database.

import json, csv, urllib, sys, os, psycopg2
from datetime import datetime, timedelta
import keys

# Open the log file
log = open("/data/sasa_airquality/metone/logs/metone.log", "a+")

# Create a function for logging/displaying output
def debugMessage(message):
    print(message)
    log.write(message + "\n")
    log.flush()
    os.fsync(log.fileno())

debugMessage("[" + str(datetime.now()) + "] Starting Met One tool.")


# Connect to the database
try:
    dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
    dbConnection.autocommit = True
    dbCursor = dbConnection.cursor()

except (KeyboardInterrupt, SystemExit):
    debugMessage("[" + str(datetime.now()) + "] Received keyboard interrupt or other system exit signal. Quitting.")
    sys.exit(-1)
except Exception as e:
    debugMessage("[" + str(datetime.now()) + "] Error connecting to database. Details: " + str(e))
    sys.exit(-1000)

# Our sensors
sensors = {"SASA_MO1":"12396", "SASA_MO2":"12397", "SASA_MO3":"12398"}

# Set the initial date
initialDate = datetime.strptime("2017-04-04","%Y-%m-%d")

# Get the current date
currentDate = datetime.today()

# Set the amount of time to change with each iteration
delta = timedelta(days=1)

# Define the Unix Epoch
epoch = datetime.utcfromtimestamp(0)

# Create a function to convert time to epoch
def unix_time_millis(dt):
    return (dt - epoch).total_seconds() * 1000.0

# For each date since the initial date
d = initialDate

# Check if the date has run before
dbCursor.execute("SELECT date FROM metonedone group by date")

allDates = {}

# store already fetched dates to dictionary
for record in dbCursor:
    allDates[record[0].strftime("%Y-%m-%d")] = 1

while d < currentDate:

    dString = d.strftime("%Y-%m-%d")

    # This skips the current loop if the date has run before
    if (dString in allDates):
        debugMessage("[" + str(datetime.now()) + "] Skipping date '" + dString + "' as it has run before.")
        d += delta
        continue

    debugMessage("[" + str(datetime.now()) + "] Running for date '" + dString + "'")

    # Figure out this date's start/end time in milliseconds since epoch
    # '%.0f' % converts to string showing 0 decimal points (if using str() it puts in scientific notation)
    startTime = '%.0f' % unix_time_millis(d)
    endTime = '%.0f' % unix_time_millis(d + delta)

    # For each sensor
    for sensor in sensors:

        apiEndpoint = "https://www.grovestreams.com/api/comp/W" + sensors[sensor] + "/stream/conc/feed?sd=" + startTime + "&ed=" + endTime + "&api_key=" + keys.apiKey;

        debugMessage("[" + str(datetime.now()) + "] Requesting data from sensor with compId 'W" + sensors[sensor] + "'")

        # Get the JSON from the API
        apiResponse = urllib.urlopen(apiEndpoint).read()

        # Parse the data
        apiData = json.loads(apiResponse)

        if (len(apiData) > 0):
            debugMessage("[" + str(datetime.now()) + "] Found data... Entering in database.")

            # For each data point in the returned array
            for entry in apiData:

                # Convert time to one postgres can use
                thisTime = datetime.fromtimestamp(float(entry['time'])/1000.)

                # Enter into database
                try:
                    dbCursor.execute("INSERT INTO metone (value, type, time, unit_id, device) VALUES (%s, %s, %s, %s, %s)", (entry['data'], "conc", thisTime, sensor, sensors[sensor]))
                except (KeyboardInterrupt, SystemExit):
                    debugMessage("[" + str(datetime.now()) + "] Received keyboard interrupt or other system exit signal. Quitting.")
                    sys.exit(-1)
                except psycopg2.Error as e:
                    # No need to log duplicity errors
                    if ("23505" not in e.pgcode):
                        debugMessage("[" + str(datetime.now()) + "] An error occurred entering data into database. Details:\n" + e.pgerror)
                        sys.exit(-1)

    # Log that this day has completed
    dbCursor.execute("INSERT INTO metonedone(date) VALUES (%s)", (dString,))

    # Go to next day
    d += delta
