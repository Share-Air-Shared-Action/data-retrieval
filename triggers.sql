-- This file is run by psql daily to update any newly-entered data

---------------------------------- Set variables ----------------------------------

\set pilotStart '2017-04-17 00:00:00-05'
\set pilotEnd '2017-04-26 00:00:00-05'

\set summerStart '2017-06-05 00:00:00-05'
\set summerEnd '2017-10-01 00:00:00-05'

\set winterStart '2017-10-01 00:00:00-05'
\set winterEnd '2018-04-01 00:00:00-05'

---------------------------------- Set the seasons in this section ----------------------------------

-- Set season based on date on aeroqualno2 table
update aeroqualno2 set season='Pilot'  where (date >= :pilotStart and date < :pilotEnd);
update aeroqualno2 set season='Summer' where (date >= :summerStart and date < :summerEnd);
update aeroqualno2 set season='Winter' where (date >= :winterStart and date < :winterEnd);

-- Set season based on date on metone table
update metone set season='Pilot' where (time >= :pilotStart and time < :pilotEnd);
update metone set season='Summer' where (time >= :summerStart and time < :summerEnd);
update metone set season='Winter' where (time >= :winterStart and time < :winterEnd);

-- Set season based on date on airterrier table
update airterrier set season='Pilot' where (time >= :pilotStart and time < :pilotEnd);
update airterrier set season='Summer' where (time >= :summerStart and time < :summerEnd);
update airterrier set season='Winter' where (time >= :winterStart and time < :winterEnd);

-- Set season based on date on aeroqualo3 table
update aeroqualo3 set season='Pilot' where (date >= :pilotStart and date < :pilotEnd);
update aeroqualo3 set season='Summer' where (date >= :summerStart and date < :summerEnd);
update aeroqualo3 set season='Winter' where (date >= :winterStart and date < :winterEnd);

-- Set season based on date on purpleairprimary table
update purpleairprimary set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd);
update purpleairprimary set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd);
update purpleairprimary set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd);

-- Set season based on date on purpleairsecondary table
update purpleairsecondary set season='Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd);
update purpleairsecondary set season='Summer' where (created_at >= :summerStart and  created_at < :summerEnd);
update purpleairsecondary set season='Winter' where (created_at >= :winterStart and created_at < :winterEnd);

---------------------------------- Set the communities in this section ----------------------------------

-- Set community on metone table based on time ranges where the sensors were set up in the communities
update metone set community='LV' where (time >= '2017-06-05 00:00:00-05' and time < '2017-07-01 00:00:00-05');
update metone set community='SE' where (time >= '2017-07-01 00:00:00-00' and time < '2017-08-01 00:00:00-00');
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time < '2017-08-31 00:00:00-00');

-- Set community on purpleairprimary table based on time ranges where the sensors were set up in the communities
update purpleairprimary set community='LV' where (created_at < '2017-07-01 00:00:00-00');
update purpleairprimary set community='SE' where (created_at >= '2017-07-01 00:00:00-00' and created_at <= '2017-08-01 00:00:00-00');
update purpleairprimary set community='PC' where (created_at >= '2017-08-09 00:00:00-00' and created_at < '2017-08-31 00:00:00-00');

---------------------------------- Set anything else in this section ----------------------------------

-- Set data type on metones
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2';
