end_date=$(date "+%j")
start_date= date "+%j" -d "- 1 days"

#startday=$(date "+%j" -d "$start_date")
#endday=$(date "+%j" -d "$end_date")
#endday=($startday +1)
echo $start_date
echo $end_date

#echo $startday
#echo $endday

curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB1&q[location]=Chicago&q[distance]=50&q[sensor_name]=&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB1.json
curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB2&q[location]=Chicago&q[distance]=50&q[sensor_name]=&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB2.json
curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB3&q[location]=Chicago&q[distance]=50&q[sensor_name]=&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB3.json
curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB4&q[location]=Chicago&q[distance]=50&q[sensor_name]=&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB4.json
curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB5&q[location]=Chicago&q[distance]=50&q[sensor_name]=&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB5.json
curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=$start_date&q[day_to]=$end_date&q[usernames]=SASA_AB6&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > /data/sasa_airquality/airbeamterrier/SASA_AB6.json
