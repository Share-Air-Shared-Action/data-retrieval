# This file downloads the data for Met One devices
# Gets the compIds from the provided arguments
# e.x. curlmetone.sh 12396 12397 12398

# Set the path of the working directory
workingDir="/data/sasa_airquality/metone"

# Set the path of the download directory
downloadDir="/data/sasa_airquality/metone/downloads"

# Set the name of the log file
logFile="curlmetone.log"

# Check if arguments supplied
if [ $# -eq 0 ]
  then
    # Set the error text
    error="[$(date)] No compIds supplied. Please supply compIds (e.x. curlmetone.sh 12396 12397 12398)."

    # Send the error to stderr
    echo $error 1>&2

    # Append the error to the log file.
    echo $error >> $workingDir/$logFile
    exit 1
fi

# Redirect all output to a log file
exec &>> $workingDir/$logFile

# Log the current date/time
echo "[$(date)] Starting curlmetone.sh with output directory $workingDir and download directory $downloadDir"

# Get API key
. $workingDir/apikey.sh

# Set the start and end date
end_date=$(date)
start_date=$(date -d "- 1 days")

# Convert the date to Milliseconds since Epoch as required by Met One API
startms=$(date "+%s%3N" -d "$start_date")
endms=$(date "+%s%3N" -d "$end_date")


echo "[$(date)] Downloading data between $start_date and $end_date."
echo "[$(date)] Calculated milliseconds since epoch. Start: $startms End: $endms"

for compId in "$@"
do
  echo "[$(date)] Downloading data for compId $compId..."
  curl "https://www.grovestreams.com/api/comp/W$compId/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" > "$downloadDir/$compId.json"
done
