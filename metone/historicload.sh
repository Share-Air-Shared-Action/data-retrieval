#!/bin/bash

# Get API key
. ./apikey.sh

#end_date=$(date)
#start_date= date -d "- 1 days"

start_date=$(date -d '2017-06-05')
end_date=$(date -d '2017-06-16')
#echo $end_date
echo $start_date
echo $end_date

startms=$(date -d "$start_date" "+%s%3N")
endms=$(date -d "$end_date" "+%s%3N")
echo $startms
echo $endms
#3 metone jsons
curl "https://www.grovestreams.com/api/comp/W12396/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" >> /data/sasa_airquality/metone/12396.json
curl "https://www.grovestreams.com/api/comp/W12397/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" >> /data/sasa_airquality/metone/12397.json
curl "https://www.grovestreams.com/api/comp/W12398/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" >> /data/sasa_airquality/metone/12398.json
