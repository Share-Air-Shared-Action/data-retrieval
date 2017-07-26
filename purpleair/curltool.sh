#!/bin/bash

# This file downloads data for a Purple Air device from provided arguements
# Usage: curltool.sh thingspeak_id thingspeak_apikey outputfilename

# Set the path of the output directory
outputDir="/data/sasa_airquality/purpleair/downloads/"

# Set the name of the log file
logFile="curlpurpleair.log"

# Check if arguments supplied
if [ $# -ne 3 ]
  then
    # Set the error text
    error="[$(date)] Invalid or no arguments supplied. Expects thingspeak_id, thingspeak_apikey, outputfilename."

    # Send the error to stderr
    echo $error 1>&2

    # Append the error to the log file.
    echo $error >> $outputDir$logFile
    exit 1
  else
    thingspeak_id=$1
    thingspeak_apikey=$2
    outputfilename=$3
fi

# Redirect all output to a log file
exec &>> $outputDir$logFile

# Set the start and end date
end_date=$(date "+%Y-%m-%d")
start_date=$(date --date="${end_date} -${diff} day" +%Y-%m-%d)

echo "Downloading data from Purple Air device with name $outputfilename for the date range of $start_date to $end_date using thingspeak ID $thingspeak_id and API key $thingspeak_apikey."

curl "https://thingspeak.com/channels/$thingspeak_id/feed.csv?api_key=$thingspeak_apikey&offset=0&average=&round=2&start=$start_date&end=$end_date%2000:00:00" > $outputDir$outputfilename.csv
