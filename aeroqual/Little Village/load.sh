
#cp /home/aeroqual/Little\ Village/*csv /data/sasa_airquality/aeroqual/Little\ Village/
TODAY=$(date +"%Y-%m-%d")
echo $TODAY
cp /home/aeroqual/Little\ Village/*$TODAY.csv /data/sasa_airquality/aeroqual/Little\ Village/
#sudo mv /home/aeroqual/Little\ Village/*csv /home/aeroqual/Little\ Village/doneAQ/


python makedata.py AQ_NO2_$TODAY.csv
python makedata.py AQ_O3_$TODAY.csv

pgloader aeroload.load

#for file in AQ*
#do
 # mv "$file" "${file/AQ/doneAQ}"
#done
