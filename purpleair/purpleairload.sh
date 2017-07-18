

for file in /data/sasa_airquality/purpleair/SASA_PA*
do
  python3 /data/sasa_airquality/purpleair/ijsontest.py "$file" 
done

pgloader /data/sasa_airquality/purpleair/data.load


#after load remove all csv files.
rm /data/sasa_airquality/purpleair/*csv
