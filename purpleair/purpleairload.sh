#!/bin/bash

# This file processes the downloaded files and puts them into the database

# Set the path of the input directory
inputDir="/data/sasa_airquality/purpleair/downloads"

# Set the filename of the log file
logFile="/data/sasa_airquality/purpleair/logs/purpleairload.log"

# Redirect all output to a log file
exec &>> $logFile

# Log the current date/time
echo "[$(date)] Starting purpleairload.sh with input directory $inputDir"

# For each CSV in the input directory
for file in $inputDir/SASA*.csv
do
  echo "[$(date)] Parsing $file"
  # Run the parser on the file
  python3 /data/sasa_airquality/purpleair/parseCSV.py "$file"
done

# Run the import command
pgloader $inputDir/pgloaderfile.load
