#!/bin/bash

# Set the path of the working directory
workingDir="/data/sasa_airquality/metone"

# Set the path of the download directory
downloadDir="/data/sasa_airquality/metone/downloads"

# Set the name of the log file
logFile="metoneload.log"

# Redirect all output to a log file
exec &>> $workingDir/$logFile

# Log the current date/time
echo "[$(date)] Starting metoneload.sh with working directory $workingDir"

# Run a Python script to convert the downloaded JSON to CSV.

# For each JSON file in the download directory
for file in $downloadDir/*.json
do
  echo "[$(date)] Converting $file to CSV..."

  # Set temp to the filename
  outFilename=${file##*/}

  # Change extension of filename to csv
  outFilename=${outFilename%.*}.csv

  # Run the converter on the file
  python $workingDir/json_to_csv.py : "$file" $downloadDir/$outFilename

  echo "[$(date)] Parsing $downloadDir/$outFilename..."

  # Run the parser on the file
  python $workingDir/makedata.py $downloadDir/$outFilename

done

echo "[$(date)] Loading data into database..."

# Load the CSVs into the database.
pgloader $downloadDir/metload.data
