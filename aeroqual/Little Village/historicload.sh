cp /home/aeroqual/Little\ Village/*csv /data/sasa_airquality/aeroqual/Little\ Village/

start=$(date "+%Y-%m-%d" -d '2017-06-20')
echo $start
#sudo mv /home/aeroqual/Little\ Village/*csv /home/aeroqual/Little\ Village/doneAQ/
l=(AQ_NO2_$start)
echo $l
python makedata.py AQ_NO2_$start.csv
python makedata.py AQ_O3_$start.csv
pgloader aeroload.load

#for file in AQ*
#do
 # mv "$file" "${file/AQ/doneAQ}"
#done
