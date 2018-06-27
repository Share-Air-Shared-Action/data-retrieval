-- This file is run by psql daily to update any newly-entered data

---------------------------------- Set variables ----------------------------------

\set pilotStart '\'2017-04-17 00:00:00-05\''
\set pilotEnd '\'2017-04-26 00:00:00-05\''

\set summerStart '\'2017-06-05 00:00:00-05\''
\set summerEnd '\'2017-12-31 23:59:59-05\''

\set winterStart '\'2018-01-01 00:00:00-05\''
\set winterEnd '\'2018-06-01 00:00:00-05\''

---------------------------------- Set the seasons in this section ----------------------------------

-- Set season based on date on aeroqualno2 table
update aeroqualno2 set season='Pilot'  where (date >= :pilotStart and date < :pilotEnd) and season is null;
update aeroqualno2 set season='Summer' where (date >= :summerStart and date < :summerEnd) and season is null;
update aeroqualno2 set season='Winter' where (date >= :winterStart and date < :winterEnd) and season is null;

-- Set season based on date on metone table
update metone set season='Pilot' where time < '2017-06-01 00:00:00-05' and season is null;
update metone set season='Summer' where (time >= '2017-06-01 00:00:00-05' and time < '2017-12-31 23:59:59-05') and season is null;
update metone set season='Winter' where (time >= :winterStart and time < :winterEnd) and season is null;

-- Set season based on date on airterrier table
update airterrier set season='Pilot' where (time >= :pilotStart and time < :pilotEnd) and season is null;
update airterrier set season='Summer' where (time >= :summerStart and time < :summerEnd) and season is null;
update airterrier set season='Winter' where (time >= :winterStart and time < :winterEnd) and season is null;

-- Set season based on date on aeroqualo3 table
update aeroqualo3 set season='Pilot' where (date >= :pilotStart and date < :pilotEnd) and season is null;
update aeroqualo3 set season='Summer' where (date >= :summerStart and date < :summerEnd) and season is null;
update aeroqualo3 set season='Winter' where (date >= :winterStart and date < :winterEnd) and season is null;

-- Set season based on date on purpleair table
update purpleair_se set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleair_se set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleair_se set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

update purpleair_sl set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleair_sl set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleair_sl set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

update purpleair_nb set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleair_nb set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleair_nb set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

update purpleair_pc set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleair_pc set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleair_pc set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

update purpleair_lv set season= 'Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleair_lv set season= 'Summer'  where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleair_lv set season= 'Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

-- Set season based on date on purpleairsecondary table
update purpleairsecondary set season='Pilot' where (created_at >= :pilotStart and created_at < :pilotEnd) and season is null;
update purpleairsecondary set season='Summer' where (created_at >= :summerStart and  created_at < :summerEnd) and season is null;
update purpleairsecondary set season='Winter' where (created_at >= :winterStart and created_at < :winterEnd) and season is null;

---------------------------------- Set the communities in this section ----------------------------------

-- Set community on metone table based on time ranges where the sensors were set up in the communities
update metone set community='LV' where (time >= '2017-06-01 00:00:00-05' and time < '2017-07-01 00:00:00-05') and community != 'LV';
update metone set community='LV' where time <= '2017-06-04 00:00:00-05' and unit_id='SASA_MO2';
update metone set community='SE' where (time >= '2017-07-01 00:00:00-00' and time < '2017-08-01 00:00:00-00') and community != 'SE';
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time < '2017-09-02 00:00:00-00') and community != 'PC';
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time <= '2017-09-02 00:00:00-00') and unit_id='SASA_MO2';
update metone set community='SL' where (time >= '2017-09-11 00:00:00-00' and time < '2017-10-03 00:00:00-00') and community != 'SL';
update metone set community='SL' where (date(time) >= date('2017-09-11') and date(time) <= date('2017-10-03')) and unit_id='SASA_MO2';
update metone set community='NB' where (time >= '2017-10-06 00:00:00-00' and time < '2017-10-31 00:00:00-00') and community != 'NB';

-- Set community on purpleairprimary table based on time ranges where the sensors were set up in the communities
update purpleairprimary set community='LV' where (created_at < '2017-07-01 00:00:00-00') and community != 'LV';
update purpleairprimary set community='SE' where (created_at >= '2017-07-01 00:00:00-00' and created_at <= '2017-08-01 00:00:00-00') and community != 'SE';
update purpleairprimary set community='PC' where (created_at >= '2017-08-09 00:00:00-00' and created_at < '2017-08-31 00:00:00-00') and community != 'PC';

---------------------------------- Set anything else in this section ----------------------------------

-- Check for errors on PM values (purpleairprimary, metone, airterrier)
update metone set error='1' where value > 1000 and (type='conc' or type='pm25' or type='pm10') and error is distinct from 1;
update purpleair_sl set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update purpleair_se set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update purpleair_nb set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update purpleair_pc set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update purpleair_lv set error='1' where pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000 and error is distinct from 1;
update airterrier set error='1' where measurement_type = 'Particulate Matter' and measured_value > 1000 and error is distinct from 1;

-- Check for lines where lat/long not set (airterrier)
update airterrier set error='1' where latitude = 0 and error is distinct from 1;
update airterrier set error='1' where longitude = 0 and error is distinct from 1;

-- Set data type on metones for LV
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='LV' and type<>'pm25';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='LV' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='LV' and type<>'pm10';
--setting the concentration type of LV for SASA_MO2 as PM2.5
update metone set community='LV' where time < '2017-06-05 00:00:00-05' and unit_id='SASA_MO2';
update metone set type='pm25' where community='LV' and unit_id='SASA_MO2' and type='conc';
update metone set type='pm25',community='LV' where date(time)>=date('2017-04-05') and date(time)<=date('2017-06-06') and unit_id='SASA_MO1';

-- Set data type on metones for PC
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='PC' and type<>'pm10';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='PC' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='PC' and type<>'pm10';
update metone set type='pm10',community='PC' where date(time)>=date('2017-08-31') and date(time)<=date('2017-09-01') and unit_id='SASA_MO1';
update metone set type='pm25' where season='Summer' and type='conc' and community='PC' and (time >= '2017-08-30 00:00:00-00' and time <= '2017-09-02 00:00:00-00');
update metone set community='PC',type='pm10' where season='Summer' and unit_id='SASA_MO3' and type='conc' and date(time) in (date('2017-08-31'),date('2017-09-01'));
update metone set community='LV',type='pm10' where season='Pilot' and unit_id='SASA_MO3' and type='conc';

-- Set data type on metones for NB
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='NB' and type<>'pm25';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO2' and community='NB' and type<>'pm10';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO3' and community='NB' and type<>'pm25';

-- Set data type on metones for SL
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='SL' and type<>'pm10';
update metone set type='pm10',community='SL' where date(time)>=date('2017-10-02') and date(time)<=date('2017-10-03') and unit_id='SASA_MO1';

-- Set data type on metones for SE
update metone set type='pm25' where type='conc' and date(time)>=date('2017-07-24') and date(time)<=date('2017-08-07') and community='SE' and season='Summer';

-- devices having reading less than 200 readings in december, unsure why the devices were turned on in december when it was not supposed to be
update purpleair_se set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleair_se where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
update purpleair_sl set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleair_sl where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
update purpleair_nb set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleair_nb where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
update purpleair_pc set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleair_pc where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
update purpleair_lv set error=1 where device_name in (select device_name from (select count(*) cnt,device_name from purpleair_lv where to_char(created_at, 'YYYY-MM') = '2017-12' group by device_name) tb where cnt<200) and to_char(created_at, 'YYYY-MM') = '2017-12' and error is distinct from 1;
-- Check errors for questionable data in purpleairprimary
update purpleair_nb set error=1 where to_char(created_at,'YYYY')='2018' and error is distinct from 1; -- setting all the NB community data of 2018 to error
update purpleair_lv set error=1 where (device_name='SASA_PA1_LV_W' or device_name='SASA_PA1_LV_WB') and date(created_at)=date('2018-03-10') and error is distinct from 1; -- 103 readings for each devices on 10th, the continous reading is from 13th
update purpleair_lv set error=1 where (device_name='SASA_PA5_LV_W' or device_name='SASA_PA5_LV_WB') and date(created_at)=date('2018-01-02') and error is distinct from 1; -- sensor A has 40 and B has 38 readings respectively on 2nd, the continous reading is from 11th
update purpleair_se set error=1 where (device_name='SASA_PA7_SE_W' or device_name='SASA_PA7_SE_WB') and date(created_at)=date('2017-12-26') and error is distinct from 1; -- 30 readings each on dec 26th and the continous readings is from March 24th
update purpleair_se set error=1 where device_name='SASA_PA2_SE_S2' and to_char(created_at,'YYYY-MM-DD')='2017-08-08'; -- 32 readings on 8th with a hours gap on 7th
update purpleair_se set error=1 where device_name='SASA_PA9_SE_S4' and date(created_at)> date('2017-08-09'); -- The device was turned on October for few minutes with 2 readings on October 6th
update purpleair_sl set error=1 where device_name='SASA_PA2_SL_W' or device_name='SASA_PA2_SL_WB' and date(created_at)=date('2018-03-09'); -- removing stray readings on March 9th with 36 readings on sensor A and 37 for B

---Check for runs in Airterrier table that are less than a minute and remove
UPDATE airterrier SET error=1 WHERE session_title IN (select session_title from airterrier group by session_title having EXTRACT(EPOCH FROM (max(time) - min(time))) < 60 ) and error is distinct from 1;
-- The runs are test runs setting as error
update airterrier set error=1 where session_title='SLtest_0910AM';
update airterrier set error=1 where session_title='SLTEST_0910TRAINING';
update airterrier set error=1 where session_title='SLtest1_0910am';
update airterrier set error=1 where session_title='sltest1_0919am';
update airterrier set error=1 where session_title='SLTest3_0908PM';
update airterrier set error=1 where session_title='SLTEST4_0908AM';
update airterrier set error=1 where session_title='sl_testrun_crash2';

-- removing incorrect two stationary locations for SASA_PA2 and SASA_PA2B and inserting with the correct latlong location
delete from stationarylocations where unit_id='SASA_PA2B' or unit_id='SASA_PA2';
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA2',41.84061,-87.734597,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA2B',41.84061,-87.734597,'LV');

-- renaming data from device SASA_PA2 and SASA_PA2B for summer season into summer nameToShow
update purpleair_lv set device_name='SASA_PA2_LV_S' where device_name='SASA_PA2' and date(created_at)='2017-06-08';
update purpleair_lv set device_name='SASA_PA2_LV_SB' where device_name='SASA_PA2B' and date(created_at)='2017-06-08';

-- assigning the season for all dates before June 8th, 2017 as pilotEnd
update purpleair_lv set season='Pilot' where date(created_at)<='2017-06-07' and season!='Summer';

-- Updating any summer devices season set to pilot back to summer
update purpleair_lv set season='Summer' where device_name='SASA_PA5_LV_SB' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA5_LV_S' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA8_LV_SB' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA8_LV_S' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA4_LV_S' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA6_LV_S' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA4_LV_SB' and season='Pilot';
update purpleair_lv set season='Summer' where device_name='SASA_PA6_LV_SB' and season='Pilot';

-- Setting device readings to error when the device was switched on one day on March 22nd for pilot season
update purpleair_lv set error=1 where device_name='SASA_PA4' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA7B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA8' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA10' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA1' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA2' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA6' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA7' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA1B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA5B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA5' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA6B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA8B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA3' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA4B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA2B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA10B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA3B' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA9' and season='Pilot' and date(created_at)='2017-03-22';
update purpleair_lv set error=1 where device_name='SASA_PA9B' and season='Pilot' and date(created_at)='2017-03-22';

-- renaming the devices reading after June 1st 2017 as summer devices
update purpleair_lv set device_name='SASA_PA4_LV_S',season='Summer' where device_name='SASA_PA4' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA8_LV_S',season='Summer' where device_name='SASA_PA8' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA6_LV_S',season='Summer' where device_name='SASA_PA6' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA6_LV_SB',season='Summer' where device_name='SASA_PA6B' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA8_LV_SB',season='Summer' where device_name='SASA_PA8B' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA4_LV_SB',season='Summer' where device_name='SASA_PA4B' and season='Pilot' and date(created_at)>date('2017-06-01');


--One day device was switched on inbetween for 3 readings
update metone set error=1 where date(time)=date('2017-05-30') and season='Pilot' and unit_id='SASA_MO1';
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO1';
--One day device was switched then continue readings is from 13th April
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO2';
--One day device was switched on inbetween for 6 readings
update metone set error=1 where date(time)=date('2017-08-11') and season='Summer' and unit_id='SASA_MO2';
--One day devices was switched on with 25 readings
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO3';
