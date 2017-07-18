curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=171&q[day_to]=172&q[usernames]=SASA_AB1&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > SASA_AB1.json
#curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=162&q[day_to]=163&q[usernames]=SASA_AB2&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m"> SASA_AB2.json 
#curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=171&q[day_to]=172&q[usernames]=SASA_AB3&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > SASA_AB3.json
#curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=171&q[day_to]=172&q[usernames]=SASA_AB4&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > SASA_AB4.json
#curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=170&q[day_to]=171&q[usernames]=SASA_AB5&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > SASA_AB5.json
#curl -g "http://aircasting.org/api/sessions.json?page=0&page_size=50&q[measurements]=true&q[time_from]=0&q[time_to]=2359&q[day_from]=172&q[day_to]=173&q[usernames]=SASA_AB6&q[location]=Chicago&q[distance]=50&q[sensor_name]=AirBeam-PM&q[unit_symbol]=%C2%B5g/m" > SASA_AB6.json

#python3 ijsontest.py SASA_AB1.json
#python3 ijsontest.py SASA_AB2.json
#python3 ijsontest.py SASA_AB3.json
#python3 ijsontest.py SASA_AB4.json
#python3 ijsontest.py SASA_AB5.json
#python3 ijsontest.py SASA_AB6.json

#pgloader pgloaderscript.load
