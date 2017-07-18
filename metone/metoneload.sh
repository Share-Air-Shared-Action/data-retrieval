python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12396.json /data/sasa_airquality/metone/12396.csv
python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12397.json /data/sasa_airquality/metone/12397.csv
python /data/sasa_airquality/metone/json_to_csv.py : /data/sasa_airquality/metone/12398.json /data/sasa_airquality/metone/12398.csv

python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12396.csv
python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12397.csv
python /data/sasa_airquality/metone/makedata.py /data/sasa_airquality/metone/12398.csv

#pgloader /data/sasa_airquality/metone/metload.data
