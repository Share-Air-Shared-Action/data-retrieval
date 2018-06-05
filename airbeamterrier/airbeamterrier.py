# This file gets a list of sessions from the Aircasting API, then downloads the JSON for each session from the API, parses it and puts it into the database

import json, urllib, sys, os, psycopg2, pytz
from datetime import datetime, timedelta
import keys

# Open the log file
log = open("/data/sasa_airquality/airbeamterrier/logs/airbeamterrier.log", "a+")

# Set the initial date
initialDate = datetime.strptime("2017-04-01","%Y-%m-%d")

# Get the current date
currentDate = datetime.today()

# Set the amount of time to change with each iteration
delta = timedelta(days=1)

# Create a function for logging/displaying output
def debugMessage(message):
    print(message)
    log.write(message + "\n")
    log.flush()
    os.fsync(log.fileno())

# Set the "usernames" for the API call
# These may be changed if they add a new phone
usernames = ["UCAir","setaskforce","SASA_SE4","setasforce7","SASA_NB1","PCR SASA_ABAG1", "PCR SASA_ABAG2", "PCR SASA_ABAG4", "PCR SASA_ABAG6", "PCR SASA_ABAG8", "SASA_AB1", "SASA_AB2", "SASA_AB3", "SASA_AB4", "SASA_AB5", "SASA_AB6", "SASA_AB7", "SASA_AB8", "SASA_AB9","SASA_ABSL1", "SASA_ABSL3","SASA_ABSL6","SASA_ABSL7","SASA_ABSL8","SASA_ABSL4"]

# Set the timezone
tz = pytz.timezone("America/Chicago")

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

    sys.exit(-1)

# For each date since the initial date
d = initialDate
while d <= currentDate:

    # Set the date data for this iteration
    end_date = d + delta
    startString = d.timetuple().tm_yday
    endString = end_date.timetuple().tm_yday

    for username in usernames:
        allSessionsURL = "http://aircasting.org/api/sessions.json?page=0&page_size=50&q%5Btime_from%5D=0&q%5Btime_to%5D=2359&q%5Bday_from%5D=" + str(startString) + "&q%5Bday_to%5D=" + str(endString) + "&q%5Busernames%5D=" + username + "&q%5Blocation%5D=Chicago&q%5Bunit_symbol%5D=%C2%B5g%2Fm"

        debugMessage("[" + str(datetime.now()) + "] Requesting sessions for " + username + " from day " + str(startString) + " to " + str(endString))

        try:
            # Get the JSON from the URL
            allSessionsResponse = urllib.urlopen(allSessionsURL).read()

            # Parse the JSON
            allSessionsData = json.loads(allSessionsResponse)

            # Debugging message
            debugMessage("[" + str(datetime.now()) + "] Got " + str(len(allSessionsData)) + " sessions.")

            sessionCount = 1

            # For each entry in the JSON
            for item in allSessionsData:

                # Get its ID
                currentID = item['id']

                # Time to request the JSON for the specific ID
                sessionURL = "http://aircasting.org/api/sessions/" + str(currentID) + ".json"

                debugMessage("[" + str(datetime.now()) + "] [" + str(sessionCount) + " of " + str(len(allSessionsData)) + "] Requesting data from session " + str(currentID) + " of " + username)

                sessionCount += 1

                try:
                    # Get the JSON from the URL
                    currentSessionResponse = urllib.urlopen(sessionURL).read()

                    # Parse the JSON
                    currentSessionData = json.loads(currentSessionResponse)

                    # Set the session title
                    session_title = currentSessionData['title'].strip()

                    # Check if this session_title has been entered
                    dbCursor.execute("SELECT session_title FROM airterrierdone where session_title = %s",(session_title,))

                    # This skips the current loop if the session_title has been entered before
                    if (dbCursor.fetchone() is not None):
                        debugMessage("[" + str(datetime.now()) + "] Skipping session_title '" + session_title + "' as it has already been entered.")
                        continue

                    debugMessage("[" + str(datetime.now()) + "] New session data found. Session title: " + session_title)

                    # For each stream within the current session
                    for streamname, streamdata in currentSessionData['streams'].iteritems():

                        # Set the measurement type first
                        measurement_type = streamdata['measurement_type']

                        # Then print some debugging info
                        debugMessage("[" + str(datetime.now()) + "] Entering data from stream " + streamname + " (" + measurement_type+ ") into database...")

                        # Set the rest of the values
                        average_value = streamdata['average_value']
                        sensor_package_name = streamdata['sensor_package_name']
                        unit_name = streamdata['unit_name']
                        sensor_name = streamdata['sensor_name']
                        measurementCount = 1

                        debugMessage("[" + str(datetime.now()) + "] Found " + str((streamdata['size'])) + " records in this stream.")

                        # For each specific measurement within the stream
                        for measurement in streamdata['measurements']:

                            # Print the status of record entry in database.
                            print("\rEntering record " + str(measurementCount) + " of " + str((streamdata['size'])) + " into database..."),
                            if (measurementCount == streamdata['size']):
                                print("\r")
                                debugMessage("[" + str(datetime.now()) + "] Finished entering records for stream.")
                            measurementCount += 1

                            # Set the values for the measurement
                            latitude = measurement['latitude']
                            longitude = measurement['longitude']

                            # Add the timezone to the time (conver from string to datetime object first)
                            time = tz.localize(datetime.strptime(measurement['time'], '%Y-%m-%dT%H:%M:%SZ'))

                            measured_value = measurement['value']

                            try:
                                dbCursor.execute("""INSERT INTO airterrier (session_title, username, average_value, measurement_type, sensor_name, sensor_package_name, unit_name, latitude, longitude, measured_value, time)
                                                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",(session_title, username, average_value, measurement_type, sensor_name, sensor_package_name, unit_name, latitude, longitude, measured_value, time))
                            except (KeyboardInterrupt, SystemExit):
                                debugMessage("[" + str(datetime.now()) + "] Received keyboard interrupt or other system exit signal. Quitting.")
                                sys.exit(-1)
                            except psycopg2.Error as e:
                                # No need to log duplicity errors
                                if ("23505" not in e.pgcode):
                                    debugMessage("[" + str(datetime.now()) + "] An error occurred entering data into database. Details:\n" + e.pgerror)

                    # Log that this session_title has completed
                    dbCursor.execute("INSERT INTO airterrierdone(session_title) VALUES (%s)", (session_title,))
                except (KeyboardInterrupt, SystemExit):
                    debugMessage("[" + str(datetime.now()) + "] Received keyboard interrupt or other system exit signal. Quitting.")
                    sys.exit(-1)
                except Exception as e:
                    debugMessage("[" + str(datetime.now()) + "] An error occurred requesting or processing data from session " + str(currentID) + " of " + username + ". Details: " + str(e))
        except (KeyboardInterrupt, SystemExit):
            debugMessage("[" + str(datetime.now()) + "] Received keyboard interrupt or other system exit signal. Quitting.")
            sys.exit(-1)
        except Exception as e:
            debugMessage("[" + str(datetime.now()) + "] An error occurred requesting sessions for " + username + " from day " + str(startString) + " to " + str(endString) + ". Details: " + str(e))

    # Go to next day
    d += delta
