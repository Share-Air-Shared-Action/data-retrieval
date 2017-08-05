# This file gets a list of sessions from the Aircasting API, then downloads the JSON for each session from the API, parses it and puts it into the database

import json, urllib, sys, psycopg2
from datetime import datetime
import keys

# Set the "usernames" for the API call
usernames = ["SASA_AB1", "SASA_AB2", "SASA_AB3", "SASA_AB4", "SASA_AB5", "SASA_AB6"]

# Get the current day of the year
#today_day_of_year = datetime.now().timetuple().tm_yday
# FOR TESTING PURPOSES
today_day_of_year = 215

# Get yesterday's day of the year
#yesterday_day_of_year = today_day_of_year - 1
# FOR TESTING PURPOSES
yesterday_day_of_year = 200

for username in usernames:
    allSessionsURL = "http://aircasting.org/api/sessions.json?page=0&page_size=50&q%5Btime_from%5D=0&q%5Btime_to%5D=2359&q%5Bday_from%5D=" + str(yesterday_day_of_year) + "&q%5Bday_to%5D=" + str(today_day_of_year) + "&q%5Busernames%5D=" + username + "&q%5Blocation%5D=Chicago&q%5Bunit_symbol%5D=%C2%B5g%2Fm"

    print("Requesting sessions for " + username + " from day " + str(yesterday_day_of_year) + " to " + str(today_day_of_year))

    try:
        # Get the JSON from the URL
        allSessionsResponse = urllib.urlopen(allSessionsURL).read()

        # Parse the JSON
        allSessionsData = json.loads(allSessionsResponse)

        # For each entry in the JSON
        for item in allSessionsData:

            # Get its ID
            currentID = item['id']

            # Time to request the JSON for the specific ID
            sessionURL = "http://aircasting.org/api/sessions/" + str(currentID) + ".json"

            print("Requesting data from session " + str(currentID) + " of " + username)

            try:
                # Get the JSON from the URL
                currentSessionResponse = urllib.urlopen(sessionURL).read()

                # Parse the JSON
                currentSessionData = json.loads(currentSessionResponse)

                # Set the session title
                session_title = currentSessionData['title']
                print("Session data found. Session title: " + session_title)

                # For each stream within the current session
                for streamname, streamdata in currentSessionData['streams'].iteritems():

                    # Set the measurement type first
                    measurement_type = streamdata['measurement_type']

                    # Then print some debugging info
                    print("Entering data from stream " + streamname + " (" + measurement_type+ ") into database...")

                    # Set the rest of the values
                    average_value = streamdata['average_value']
                    sensor_package_name = streamdata['sensor_package_name']
                    unit_name = streamdata['unit_name']

                    # For each specific measurement within the stream
                    for measurement in streamdata['measurements']:

                        # Set the values for the measurement
                        latitude = measurement['latitude']
                        longitude = measurement['longitude']
                        time = measurement['time']
                        measured_value = measurement['value']

                        # Finally, we need to enter this data into the database
                        try:
                            dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
                            dbConnection.autocommit = True

                        except:
                            print("Error connecting to database...")
                            sys.exit(-1)

                        try:
                            dbCursor = dbConnection.cursor()

                            dbCursor.execute("""INSERT INTO airterrier (session_title, username, average_value, measurement_type, sensor_package_name, unit_name, latitude, longitude, measured_value, time)
                                             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",(session_title, username, average_value, measurement_type, sensor_package_name, unit_name, latitude, longitude, measured_value, time))

                        except psycopg2.Error as e:
                            print("An error occurred entering data into database. Details:\n" + e.pgerror)

            except:
                print("An error occurred requesting or processing data from session " + str(currentID) + " of " + username)
    except:
        print("An error occurred requesting sessions for " + username + " from day " + str(yesterday_day_of_year) + " to " + str(today_day_of_year))
