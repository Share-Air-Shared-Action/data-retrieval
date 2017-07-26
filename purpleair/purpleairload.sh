#!/bin/bash

# This file processes the downloaded files and puts them into the database

# Set the path of the input directory
inputDir="/data/sasa_airquality/purpleair/downloads"

# For each CSV in the input directory
for file in $inputDir/SASA*.csv
do
  # Run the parser on the file
  python3 /data/sasa_airquality/purpleair/parseCSV.py "$file"
done

# For each parsed CSV
for file in $inputDir/newSASA*.csv
do
  # Run the import command on the file
   pgloader --type csv --with "skip header = 2" --with "fields fields optionally enclosed by '\"'" --with "fields escaped by backslash-quote" --with "fields terminated by ','" "$file" postgresql://postgres@localhost:5432/sasa_airquality?purpleairprimary
done
