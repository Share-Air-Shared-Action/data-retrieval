-- Running this will dump a CSV of the database tables below to /data/sasa_airquality/dump/*.csv

COPY aeroqualno2 TO '/data/sasa_airquality/dump/aeroqualno2.csv' DELIMITER ',' CSV HEADER;
COPY aeroqualo3 TO '/data/sasa_airquality/dump/aeroqualo3.csv' DELIMITER ',' CSV HEADER;

COPY airterrier TO '/data/sasa_airquality/dump/airterrier.csv' DELIMITER ',' CSV HEADER;

COPY metone TO '/data/sasa_airquality/dump/metone.csv' DELIMITER ',' CSV HEADER;

COPY purpleairprimary TO '/data/sasa_airquality/dump/purpleairprimary.csv' DELIMITER ',' CSV HEADER;

COPY stationarylocations TO '/data/sasa_airquality/dump/stationarylocations.csv' DELIMITER ',' CSV HEADER;
