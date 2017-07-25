#!/bin/bash

# This helps with debugging
set -x #echo on

# Run a Python script to convert the downloaded JSON to CSV.
python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12396.json /data/sasa_airquality/metone/12396.csv
python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12397.json /data/sasa_airquality/metone/12397.csv
python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12398.json /data/sasa_airquality/metone/12398.csv

# Run a Python script to process the converted CSV to change data types and add columns before import.
python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12396.csv
python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12397.csv
python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12398.csv

# Load the CSVs into the database.
pgloader /data/sasa_airquality/metone/metload.data
