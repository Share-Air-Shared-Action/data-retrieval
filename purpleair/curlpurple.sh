#!/bin/bash

# Get API key
. ./apikey.sh

diff=1
end_date=$(date "+%Y-%m-%d")
start_date=$(date --date="${end_date} -${diff} day" +%Y-%m-%d)
#start_date= date -d "- 1 days" '+%Y-%m-%d'
echo $start_date
echo "--"
echo $end_date

# older 20 purple air csvs (keep for future use)
#curl "https://api.thingspeak.com/channels/246039/feeds.csv?api_key=${ts246039apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA1.csv
#curl "https://api.thingspeak.com/channels/246041/feeds.csv?api_key=${ts246041apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA12.csv
#curl "https://api.thingspeak.com/channels/246049/feeds.csv?api_key=${ts246049apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA2.csv
#curl "https://api.thingspeak.com/channels/246051/feeds.csv?api_key=${ts246051apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA22.csv
#curl "https://api.thingspeak.com/channels/246087/feeds.csv?api_key=${ts246087apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA3.csv
#curl "https://api.thingspeak.com/channels/246089/feeds.csv?api_key=${ts246089apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA32.csv
#curl "https://api.thingspeak.com/channels/246044/feeds.csv?api_key=${ts246044apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA4.csv
#curl "https://api.thingspeak.com/channels/246046/feeds.csv?api_key=${ts246046apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA42.csv
#curl "https://api.thingspeak.com/channels/246094/feeds.csv?api_key=${ts246094apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA5.csv
#curl "https://api.thingspeak.com/channels/246096/feeds.csv?api_key=${ts246096apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA52.csv
#curl "https://api.thingspeak.com/channels/246058/feeds.csv?api_key=${ts246058apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA6.csv
#curl "https://api.thingspeak.com/channels/246060/feeds.csv?api_key=${ts246060apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA62.csv
#curl "https://api.thingspeak.com/channels/246035/feeds.csv?api_key=${ts246035apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA7.csv
#curl "https://api.thingspeak.com/channels/246037/feeds.csv?api_key=${ts246037apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA72.csv
#curl "https://api.thingspeak.com/channels/246063/feeds.csv?api_key=${ts246063apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA8.csv
#curl "https://api.thingspeak.com/channels/246065/feeds.csv?api_key=${ts246065apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA82.csv
#curl "https://api.thingspeak.com/channels/246070/feeds.csv?api_key=${ts246070apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA9.csv
#curl "https://api.thingspeak.com/channels/246072/feeds.csv?api_key=${ts246072apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA92.csv
#curl "https://api.thingspeak.com/channels/246114/feeds.csv?api_key=${ts246114apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA10.csv
#curl "https://api.thingspeak.com/channels/246116/feeds.csv?api_key=${ts246116apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" > /data/sasa_airquality/purpleair/SASA_PA102.csv


#new pa devices
curl "https://thingspeak.com/channels/286620/feed.csv?api_key=${ts286620apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end={$end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA1.csv
curl "https://thingspeak.com/channels/286622/feed.csv?api_key=${ts286622apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA1B.csv
curl "https://thingspeak.com/channels/285024/feed.csv?api_key=${ts285024apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA2_LV_S.csv
curl "https://thingspeak.com/channels/285026/feed.csv?api_key=${ts285026apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA2_LV_SB.csv
curl "https://thingspeak.com/channels/282500/feed.csv?api_key=${ts282500apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA3_LV_S.csv
curl "https://thingspeak.com/channels/282502/feed.csv?api_key=${ts282502apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA3_LV_SB.csv
curl "https://thingspeak.com/channels/282494/feed.csv?api_key=${ts282494apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA4_LV_S.csv
curl "https://thingspeak.com/channels/282496/feed.csv?api_key=${ts282496apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA4_LV_SB.csv
curl "https://thingspeak.com/channels/283937/feed.csv?api_key=${ts283937apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA5_LV_S.csv
curl "https://thingspeak.com/channels/283939/feed.csv?api_key=${ts283939apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA5_LV_SB.csv
curl "https://thingspeak.com/channels/282490/feed.csv?api_key=${ts282490apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA6_LV_S.csv
curl "https://thingspeak.com/channels/282492/feed.csv?api_key=${ts282492apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA6_LV_SB.csv
curl "https://thingspeak.com/channels/282899/feed.csv?api_key=${ts282899apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA7_LV_S.csv
curl "https://thingspeak.com/channels/282901/feed.csv?api_key=${ts282901apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA7_LV_SB.csv
curl "https://thingspeak.com/channels/282825/feed.csv?api_key=${ts282825apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA8_LV_S.csv
curl "https://thingspeak.com/channels/282827/feed.csv?api_key=${ts282827apiKey}&offset=0&average=&round=2&start=${start_date}%2000:00:00&end=${end_date}%2000:00:00" >/data/sasa_airquality/purpleair/SASA_PA8_LV_SB.csv
