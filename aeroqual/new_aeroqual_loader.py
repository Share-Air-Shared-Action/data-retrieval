# This file loads aeroqual data from the upload folder

import sys, os, psycopg2, csv
from datetime import datetime
import keys

# Open the log file
logfile = open("/data/sasa_airquality/aeroqual/logs/aeroqual.log", "a+")

# Create a function for logging/displaying output
def debugMessage(message):
    debugTime = str(datetime.now())
    print("[" + debugTime + "] " + message)
    logfile.write("[" + debugTime + "] " + message + "\n")
    logfile.flush()
    os.fsync(logfile.fileno())

# Set the upload folder path
uploadFolder = "/home/aeroqual/"

# Connect to the database
try:
    dbConnection = psycopg2.connect(host=keys.hostname, user=keys.username, password=keys.password, dbname=keys.database)
    dbConnection.autocommit = True
    dbCursor = dbConnection.cursor()

except:
    debugMessage("Error connecting to database...");
    sys.exit(-1)


# Set the names of the communities (subfolders)
communities = ["Altgeld Gardens", "Little Village", "South East Environmental Task Force", "South Loop"]

# For each community
for community in communities:

    if (community == "Altgeld Gardens"):
        communityAbbreviation = "PC"
    elif (community == "Little Village"):
        communityAbbreviation = "LV"
    elif (community == "South East Environmental Task Force"):
        communityAbbreviation = "SE"
#    elif (community == "South Loop"):
#        communityAbbreviation = ""
    else:
        communityAbbreviation = ""

    debugMessage("Loading data for the community '" + community + "' using abbreviation '" + communityAbbreviation + "'")

    # For each file in current community's folder
    for file in os.listdir(uploadFolder + community):
        # Make sure it is an AeroQual CSV
        if file.startswith("AQ") and file.endswith(".csv"):
            # Open the file
            debugMessage("Loading data from '" + file + "'")
            with open(uploadFolder + community + "/" + file) as CSVfile:
                # Parse the file
                parsedCSV = csv.reader(CSVfile, delimiter=',')

                # Create a variable for the type
                checkedHeader = False
                thisDataType = None

                # row[0]: date; row[1]: Monitor ID; row[2]: Location ID; row[3]: data

                # For each row in the CSV:
                for row in parsedCSV:

                    # Check first row to see type of data
                    if (checkedHeader is False):

                        # This must be the first row of this file, so set the data type
                        thisDataType = row[3]

                        if (thisDataType == " O3(ppm)"):
                            dbtable = "aeroqualo3"
                            dbcolumn = "o3ppm"
                            unit_id = "SASA_AQ2"
                            debugMessage("File appears to contain O3 data. Inserting into '" + dbtable + "'")

                        elif (thisDataType == " NO2(ppm)"):
                            dbtable = "aeroqualno2"
                            dbcolumn = "no2ppm"
                            unit_id = "SASA_AQ1"
                            debugMessage("File appears to contain NO2 data. Inserting into '" + dbtable + "'")

                        else:
                            debugMessage("ERROR: Unrecognized data header. Skipping file.")
                            break

                        checkedHeader = True

                    # If it isn't the first row
                    else:
                        # The rest of the rows should contain data, so enter it into database

                        try:
                            dbCursor.execute("INSERT INTO " + dbtable + " (date, monitorid, locationid, " + dbcolumn + ", unit_id, community) VALUES (%s, %s, %s, %s, %s, %s)", (row[0], row[1], row[2], row[3], unit_id, communityAbbreviation))
                        except psycopg2.Error as e:
                            # Log everything but duplicity errors
                            if ("23505" not in e.pgcode):
                                debugMessage("An error occurred entering data into database. Details:\n" + e.pgerror)
            debugMessage("Finished loading data from '" + file + "'")

        else:

            debugMessage("Skipping file '" + file + "' as it does not appear to be an AeroQual CSV.")

    debugMessage("Finished loading data for the community '" + community + "'.")
