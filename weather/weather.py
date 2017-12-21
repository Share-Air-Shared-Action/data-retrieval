# This file gets weather data from Weather Underground and puts it into the database

import json, urllib, sys, os, psycopg2
from datetime import datetime
import keys

# Open the log file
logfile = open("/data/sasa_airquality/weather/weather.log", "a+")

# Create a function for logging/displaying output
def debugMessage(message):
    debugTime = str(datetime.now())
    print("[" + debugTime + "] " + message)
    logfile.write("[" + debugTime + "] " + message + "\n")
    logfile.flush()
    os.fsync(logfile.fileno())

# Set the communities as a dictionary. Will put the center lat/long as a tuple for each key
communities = {"LV" : None, "PC" : None, "SL" : None, "SE" : None, "NB" : None}

# Connect to the database
try:
    dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
    dbConnection.autocommit = True

    dbCursor = dbConnection.cursor()

except (KeyboardInterrupt, SystemExit):
    debugMessage("Received keyboard interrupt or other system exit signal. Quitting.")
    sys.exit(-1)
except Exception as e:
    debugMessage("Error connecting to database. Details: " + str(e))
    sys.exit(-1)

# Get the center lat/longs for each community
try:
    # Check if the date has run before
    dbCursor.execute("""
        SELECT AVG(latitude) AS centerLat, AVG(longitude) AS centerLong, community FROM (
            SELECT latitude, longitude, UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier
            UNION ALL
            SELECT latitude, longitude, community FROM stationarylocations
        ) AS centers group by community""")

    # Store each center value
    thisCenterValue = dbCursor.fetchone()

    # While there are records
    while (thisCenterValue is not None):
        # do stuff with thisCenterValue
        if thisCenterValue[2] in communities:
            communities[thisCenterValue[2]] = (thisCenterValue[0], thisCenterValue[1])

        # Get next record
        thisCenterValue = dbCursor.fetchone()

except (KeyboardInterrupt, SystemExit):
    debugMessage("Received keyboard interrupt or other system exit signal. Quitting.")
    sys.exit(-1)
except psycopg2.Error as e:
    # No need to log duplicity errors
    if ("23505" not in e.pgcode):
        debugMessage("An error occurred entering data into database. Details:\n" + e.pgerror)

# For each community
for key, value in communities.iteritems():
    lat = str(value[0])
    lng = str(value[1])
    community = key

    debugMessage("Getting weather for " + community + " with center of (" + lat + ", " + lng + ").")

    # Make conditions URL: (add pws:0 ex /conditions/pws:0/q/ to disable pws)
    conditionsURL = "http://api.wunderground.com/api/" + keys.wunderground + "/conditions/q/" + lat + "," + lng + ".json"

    try:
        # Get the JSON from the URL
        conditionsResponse = urllib.urlopen(conditionsURL).read()
    except (KeyboardInterrupt, SystemExit):
        debugMessage("Received keyboard interrupt or other system exit signal. Quitting.")
        sys.exit(-1)
    except:
        debugMessage("Failed to open conditions URL.")
        sys.exit(-1)

    # Parse the JSON
    conditionsData = json.loads(conditionsResponse)

    # Get the relevant weather data
    observation_time = conditionsData["current_observation"]["observation_time_rfc822"]
    temp_f = conditionsData["current_observation"]["temp_f"]
    relative_humidity = conditionsData["current_observation"]["relative_humidity"].rstrip("%")
    wind_dir = conditionsData["current_observation"]["wind_dir"]
    wind_degrees = conditionsData["current_observation"]["wind_degrees"]
    wind_mph = conditionsData["current_observation"]["wind_mph"]
    wind_gust_mph = conditionsData["current_observation"]["wind_gust_mph"]
    pressure_in = conditionsData["current_observation"]["pressure_in"]
    pressure_trend = conditionsData["current_observation"]["pressure_trend"]
    dewpoint_f = conditionsData["current_observation"]["dewpoint_f"]
    heat_index_f = conditionsData["current_observation"]["heat_index_f"]
    if (heat_index_f == "NA"):
        heat_index_f = None
    windchill_f = conditionsData["current_observation"]["windchill_f"]
    feelslike_f = conditionsData["current_observation"]["feelslike_f"]
    visibility_mi = conditionsData["current_observation"]["visibility_mi"]
    solarradiation = conditionsData["current_observation"]["solarradiation"]
    if (solarradiation == "--"):
        solarradiation = None
    UV = conditionsData["current_observation"]["UV"]
    precip_1hr_in = conditionsData["current_observation"]["precip_1hr_in"]
    precip_today_in = conditionsData["current_observation"]["precip_today_in"]

    observation_lat = conditionsData["current_observation"]["observation_location"]["latitude"]
    observation_lng = conditionsData["current_observation"]["observation_location"]["longitude"]

    # Put the data into database:
    try:
        dbCursor.execute("""INSERT INTO wundergound (observation_time, temp_f, relative_humidity, wind_dir, wind_degrees, wind_mph, wind_gust_mph, pressure_in, pressure_trend, dewpoint_f, heat_index_f, windchill_f, feelslike_f, visibility_mi, solarradiation, UV, precip_1hr_in, precip_today_in, observation_lat, observation_lng, community)
                         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",(observation_time, temp_f, relative_humidity, wind_dir, wind_degrees, wind_mph, wind_gust_mph, pressure_in, pressure_trend, dewpoint_f, heat_index_f, windchill_f, feelslike_f, visibility_mi, solarradiation, UV, precip_1hr_in, precip_today_in, observation_lat, observation_lng, community))
    except (KeyboardInterrupt, SystemExit):
        debugMessage("Received keyboard interrupt or other system exit signal. Quitting.")
        sys.exit(-1)
    except psycopg2.Error as e:
        # No need to log duplicity errors
        if ("23505" not in e.pgcode):
            debugMessage("An error occurred entering data into database. Details:\n" + e.pgerror)
