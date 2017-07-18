# Get API key
. ./apikey.sh

end_date=$(date)
start_date= date -d "- 1 days"

#start_date= date -d '2017-06-04'
#end_date= date -d '2017-06-09'
#echo $end_date
echo $start_date
echo $end_date
startms=$(date "+%s%3N" -d "$start_date")
endms=$(date "+%s%3N" -d "$end_date")
echo $startms
echo $endms
#3 metone jsons
curl "https://www.grovestreams.com/api/comp/W12396/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" > /data/sasa_airquality/metone/12396.json
curl "https://www.grovestreams.com/api/comp/W12397/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" > /data/sasa_airquality/metone/12397.json
curl "https://www.grovestreams.com/api/comp/W12398/feed?sd=$startms&ed=$endms&retStreamId&api_key=$apikey" > /data/sasa_airquality/metone/12398.json
