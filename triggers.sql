-- This file is run by psql daily to update any newly-entered data

---------------------------------- Set variables ----------------------------------

\set pilotStart '\'2017-04-17 00:00:00-05\''
\set pilotEnd '\'2017-04-26 00:00:00-05\''

\set summerStart '\'2017-06-05 00:00:00-05\''
\set summerEnd '\'2017-12-31 23:59:59-05\''

\set winterStart '\'2018-01-01 00:00:00-05\''
\set winterEnd '\'2018-06-01 00:00:00-05\''

\set onGoingStart '\'2018-06-01 00:00:00-05\''

---------------------------------- Set the seasons in this section ----------------------------------

-- Set season based on date on aeroqualno2 table
update aeroqualno2 set season='Pilot'  where (date >= :pilotStart and date < :pilotEnd) and season is null;
update aeroqualno2 set season='Summer' where (date >= :summerStart and date < :summerEnd) and season is null;
update aeroqualno2 set season='Winter' where (date >= :winterStart and date < :winterEnd) and season is null;
update aeroqualno2 set season='On-going' where (date >= :onGoingStart) and season is null;

-- Set season based on date on metone table
update metone set season='Pilot' where (time >= :pilotStart and time < :pilotEnd) and season is null;
update metone set season='Summer' where (time >= :summerStart and time < :summerEnd) and season is null;
update metone set season='Winter' where (time >= :winterStart and time < :winterEnd) and season is null;
update metone set season='On-going' where (time >= :onGoingStart) and season is null;

-- Set season based on date on airterrier table
update airterrier set season='Pilot' where (time >= :pilotStart and time < :pilotEnd) and season is null;
update airterrier set season='Summer' where (time >= :summerStart and time < :summerEnd) and season is null;
update airterrier set season='Winter' where (time >= :winterStart and time < :winterEnd) and season is null;
update airterrier set season='On-going' where (time >= :onGoingStart) and season is null;

-- Set season based on date on aeroqualo3 table
update aeroqualo3 set season='Pilot' where (date >= :pilotStart and date < :pilotEnd) and season is null;
update aeroqualo3 set season='Summer' where (date >= :summerStart and date < :summerEnd) and season is null;
update aeroqualo3 set season='Winter' where (date >= :winterStart and date < :winterEnd) and season is null;
update aeroqualo3 set season='On-going' where (date >= :onGoingStart) and season is null;

-- Set season based on date on purpleairprimary table
update purpleairprimary set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleairprimary set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleairprimary set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;
update purpleairprimary set season='On-going' where (created_at >= :onGoingStart) and season is null;

-- Set season based on date on purpleairsecondary table
update purpleairsecondary set season='Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleairsecondary set season='Summer' where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleairsecondary set season='Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;
update purpleairsecondary set season='On-going' where (created_at >= :onGoingStart) and season is null;

---------------------------------- Set the communities in this section ----------------------------------

-- Set community on metone table based on time ranges where the sensors were set up in the communities
update metone set community='LV' where (time >= '2017-06-05 00:00:00-05' and time < '2017-07-01 00:00:00-05') and community != 'LV';
update metone set community='SE' where (time >= '2017-07-01 00:00:00-00' and time < '2017-08-01 00:00:00-00') and community != 'SE';
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time < '2017-08-31 00:00:00-00') and community != 'PC';
update metone set community='SL' where (time >= '2017-09-11 00:00:00-00' and time < '2017-10-03 00:00:00-00') and community != 'SL';
update metone set community='NB' where (time >= '2017-10-06 00:00:00-00' and time < '2017-10-31 00:00:00-00') and community != 'NB';

-- Set community on purpleairprimary table based on time ranges where the sensors were set up in the communities
update purpleairprimary set community='LV' where (created_at < '2017-07-01 00:00:00-00') and community != 'LV';
update purpleairprimary set community='SE' where (created_at >= '2017-07-01 00:00:00-00' and created_at <= '2017-08-01 00:00:00-00') and community != 'SE';
update purpleairprimary set community='PC' where (created_at >= '2017-08-09 00:00:00-00' and created_at < '2017-08-31 00:00:00-00') and community != 'PC';

---------------------------------- Set anything else in this section ----------------------------------

-- Check for errors on PM values (purpleairprimary, metone, airterrier)
update metone set error='1' where value > 1000 and (type='conc' or type='pm25' or type='pm10') and error is distinct from 1;
update purpleairprimary set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update airterrier set error='1' where measurement_type = 'Particulate Matter' and measured_value > 1000 and error is distinct from 1;

-- Check for lines where lat/long not set (airterrier)
update airterrier set error='1' where latitude = 0 and error is distinct from 1;
update airterrier set error='1' where longitude = 0 and error is distinct from 1;

-- Set data type on metones for LV
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='LV' and type<>'pm25';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='LV' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='LV' and type<>'pm10';

-- Set data type on metones for PC
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='PC' and type<>'pm10';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='PC' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='PC' and type<>'pm10';

-- Set data type on metones for NB
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='NB' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO2' and community='NB' and type<>'pm10';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO3' and community='NB' and type<>'pm25';

-- Set data type on metones for SL
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='SL' and type<>'pm10';

-- Check errors for questionable data in purpleairprimary
update purpleairprimary set error=1 where community='NB' and to_char(created_at,'YYYY')='2018' and error is distinct from 1;
update purpleairprimary set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleairprimary where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
update purpleairprimary set error=1 where (device_name='SASA_PA1_LV_W' or device_name='SASA_PA1_LV_WB') and date(created_at)=date('2018-03-10') and error is distinct from 1;
update purpleairprimary set error=1 where (device_name='SASA_PA5_LV_W' or device_name='SASA_PA5_LV_WB') and date(created_at)=date('2018-01-02') and error is distinct from 1;
update purpleairprimary set error=1 where (device_name='SASA_PA7_SE_W' or device_name='SASA_PA7_SE_WB') and date(created_at)=date('2017-12-26') and error is distinct from 1;

---Check for runs in Airterrier table that are less than a minute and remove 
UPDATE airterrier SET error=1 WHERE session_title IN (select session_title from airterrier group by session_title having EXTRACT(EPOCH FROM (max(time) - min(time))) < 60 ) and error is distinct from 1;

-- The device was turned on October for few minutes
update purpleairprimary set error=1 where device_name='SASA_PA9_SE_S4' and date(created_at)> date('2017-08-09');

-- removing stray readings on March 9th
update purpleairprimary set error=1 where device_name='SASA_PA2_SL_W' or 'SASA_PA2_SL_WB' and date(created_at) < date('2017-04-01');
