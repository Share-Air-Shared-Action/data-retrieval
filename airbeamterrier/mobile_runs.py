# this file will first take the JSON files downloaded and upload them to the correct database
import psycopg2, json, os
from glob import glob
from pprint import pprint
from constants import *
conn = psycopg2.connect("dbname=sasa_airquality user=postgres")
cur = conn.cursor()

# Gets current working directory
dir = os.getcwd()
os.chdir(dir)

# List of json files in the current working directory
json_files = []

# List of lists. Every nested list is a row ready to be uploaded to the airterrier table
rows = []

# Printing and appending every JSON file found in the current working directory
for file in glob("*.json"):
    json_files.append(file)
    print(file)

# For every JSON file in the current directory
for file in json_files:
    # Open the JSON file and load it 
    with open(file) as json_data:
        d = json.load(json_data)
        # For some reason it's a list of a dict that contains one element
        data = d[0]
        print(type(data)) 

    i = 0
    # For every item in streams
    for stream in data["streams"]:
        print(stream)
        row.extend(data["title"], data["username"], stream["average_value"], stream["measurement_type"], stream["sensor_package_name"], data["unit_name"], data[""], data[""],  )
    print(rows)
#cur.execute('''INSERT INTO testtwo 
#            (session_title, username, average_value, 
#            measurement_type, sensor_package name, unit_name, 
#            latitude, longitude, measured_value,
#            time, season, error)
#            VALUES()''')
#'''
#title -> session title
#usernamt -> username
#-> average_value
#-> measuremen_ttype
#->  
#'''
