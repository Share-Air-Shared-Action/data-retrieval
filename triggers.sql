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
update aeroqualno2 set season='Summer' where (date >= '2017-06-02 00:00:00-05' and date < :summerEnd) and season is null;
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
update metone set community='LV' where (time >= '2017-06-01 00:00:00-05' and time < '2017-07-01 00:00:00-05');
update metone set community='LV' where time <= '2017-06-04 00:00:00-05' and unit_id='SASA_MO2';
update metone set community='SE' where (time >= '2017-07-01 00:00:00-00' and time < '2017-08-01 00:00:00-00');
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time < '2017-09-02 00:00:00-00');
update metone set community='PC' where (time >= '2017-08-09 00:00:00-00' and time <= '2017-09-02 00:00:00-00') and unit_id='SASA_MO2';
update metone set community='SL' where (time >= '2017-09-11 00:00:00-00' and time < '2017-10-03 00:00:00-00');
update metone set community='SL' where (date(time) >= date('2017-09-11') and date(time) <= date('2017-10-03')) and unit_id='SASA_MO2';
update metone set community='NB' where (time >= '2017-10-06 00:00:00-00' and time < '2017-10-31 00:00:00-00');

-- Set community on purpleairprimary table based on the device name
update purpleairprimary set community=substring(substring(device_name from position('_' in device_name)+1) from position('_' in substring(device_name from position('_' in device_name)+1))+1 for 2) where length(device_name)>11;

---------------------------------- Set anything else in this section ----------------------------------

-- Set data type on metones for LV
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='LV';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='LV';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='LV';
--setting the concentration type of LV for SASA_MO2 as PM2.5
update metone set community='LV' where time < '2017-06-05 00:00:00-05' and unit_id='SASA_MO2';
update metone set type='pm25' where community='LV' and unit_id='SASA_MO2' and type='conc';
update metone set type='pm25',community='LV' where date(time)>=date('2017-04-05') and date(time)<=date('2017-06-06') and unit_id='SASA_MO1';
-- Set data type on metones for PC
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='PC';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2' and community='PC';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO3' and community='PC';
update metone set type='pm10',community='PC' where date(time)>=date('2017-08-31') and date(time)<=date('2017-09-01') and unit_id='SASA_MO1';
update metone set type='pm25' where season='Summer' and type='conc' and community='PC' and (time >= '2017-08-30 00:00:00-00' and time <= '2017-09-02 00:00:00-00');
update metone set community='PC',type='pm10' where season='Summer' and unit_id='SASA_MO3' and type='conc' and date(time) in (date('2017-08-31'),date('2017-09-01'));
update metone set community='LV',type='pm10' where season='Pilot' and unit_id='SASA_MO3' and type='conc';
-- Set data type on metones for NB
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1' and community='NB';
update metone set type='pm10' where type='conc' and unit_id='SASA_MO2' and community='NB';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO3' and community='NB';
-- Set data type on metones for SL
update metone set type='pm10' where type='conc' and unit_id='SASA_MO1' and community='SL';
update metone set type='pm10',community='SL' where date(time)>=date('2017-10-02') and date(time)<=date('2017-10-03') and unit_id='SASA_MO1';
-- Set data type on metones for SE
update metone set type='pm25' where type='conc' and date(time)>=date('2017-07-24') and date(time)<=date('2017-08-07') and community='SE' and season='Summer';
-- correcting the community and type for the metone data
update metone set community='NB',type='pm10' where unit_id='SASA_MO2' and season='Summer' and date(time)>=date('2017-10-30') and date(time)<=date('2017-12-08');
update metone set community='NB',type='pm25' where unit_id='SASA_MO1' and season='Summer' and date(time)>=date('2017-10-30') and date(time)<=date('2017-12-08');
update metone set community='NB',type='pm25' where unit_id='SASA_MO3' and season='Summer' and date(time)>=date('2017-10-30') and date(time)<=date('2017-12-08');
update metone set community='SE',type='pm25' where unit_id='SASA_MO1' and season='Summer' and date(time)>=date('2017-07-31') and date(time)<=date('2017-08-07');

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

-- renaming the devices reading after June 1st 2017 as summer devices
update purpleair_lv set device_name='SASA_PA4_LV_S',season='Summer' where device_name='SASA_PA4' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA8_LV_S',season='Summer' where device_name='SASA_PA8' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA6_LV_S',season='Summer' where device_name='SASA_PA6' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA6_LV_SB',season='Summer' where device_name='SASA_PA6B' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA8_LV_SB',season='Summer' where device_name='SASA_PA8B' and season='Pilot' and date(created_at)>date('2017-06-01');
update purpleair_lv set device_name='SASA_PA4_LV_SB',season='Summer' where device_name='SASA_PA4B' and season='Pilot' and date(created_at)>date('2017-06-01');
-- renaming device_name on four days in July to the new device naming convention
update purpleair_se set device_name='SASA_PA9_SE_S4' where device_name='SASA_PA9' and date(created_at)>=date('2017-07-14') and date(created_at)<=date('2017-07-17');
update purpleair_se set device_name='SASA_PA9_SE_S4B' where device_name='SASA_PA9B' and date(created_at)>=date('2017-07-14') and date(created_at)<=date('2017-07-17');
update purpleair set device_name='SASA_PA6_SL_S' where device_name='SASA_PA2_PC_S' and date(created_at)>=date('2017-09-14');
update purpleair set device_name='SASA_PA6_SL_SB' where device_name='SASA_PA2_PC_SB' and date(created_at)>=date('2017-09-14');

-- season for airterrier devices
update airterrier set season='Pilot' where session_title in ('LV1_0428PM','LV1_0427PM','LV2_0427PM');
update airterrier set season='Pilot' where session_title in ('PC1_0530pm');

------------------------------------------Check for stray readings and update error field ----------------------------

-- Airterrier
UPDATE airterrier SET error=1 WHERE session_title IN (select session_title from airterrier group by session_title having EXTRACT(EPOCH FROM (max(time) - min(time))) < 60 ) and error is distinct from 1; --Check for runs in Airterrier table that are less than a minute and remove
update airterrier set error='1' where measurement_type = 'Particulate Matter' and measured_value > 1000 and error is distinct from 1; -- the value of readings for PM is more than 1000
-- Check for lines where lat/long not set (airterrier)
update airterrier set error='1' where latitude = 0 and error is distinct from 1;
update airterrier set error='1' where longitude = 0 and error is distinct from 1;
-- Individual runs that were used for testing
update airterrier set error=1 where session_title='SLtest_0910AM';
update airterrier set error=1 where session_title='SLTEST_0910TRAINING';
update airterrier set error=1 where session_title='SLtest1_0910am';
update airterrier set error=1 where session_title='sltest1_0919am';
update airterrier set error=1 where session_title='SLTest3_0908PM';
update airterrier set error=1 where session_title='SLTEST4_0908AM';
update airterrier set error=1 where session_title='sl_testrun_crash2';
update airterrier set error=1 where session_title='LV_M1_TESTTEST';

-- aeroqualno2
update aeroqualno2 set error=1 where unit_id='SASA_AQ1' and date(date) in (date('2017-05-03'),date('2017-05-05')); -- switched on two days shows readings of SE and LV on different days with 3 and 63 readings respectively

-- MetOne
update metone set error='1' where value > 1000 and (type='conc' or type='pm25' or type='pm10') and error is distinct from 1; -- the value is more than 1000
--One day device was switched on inbetween for 3 readings
update metone set error=1 where date(time)=date('2017-05-30') and season='Pilot' and unit_id='SASA_MO1';
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO1';
--One day device was switched then continue readings is from 13th April
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO2';
--One day device was switched on inbetween for 6 readings
update metone set error=1 where date(time)=date('2017-08-11') and season='Summer' and unit_id='SASA_MO2';
--One day devices was switched on with 25 readings
update metone set error=1 where date(time)=date('2017-04-05') and season='Pilot' and unit_id='SASA_MO3';

-- Purpleair
update purpleair set error=1 where date(created_at)<=date('2017-04-13'); -- everything before April 13th
update purpleair set error=1 where (pm1_cf_atm_ugm3 > 1000 or pm25_cf_atm_ugm3 > 1000 or pm10_cf_atm_ugm3 > 1000) and error is distinct from 1; -- If the readings are above 1000
update purpleair set error=1 where (device_name='SASA_PA9' or device_name='SASA_PA9B') and date(created_at) in (date('2017-04-20'),date('2017-05-30'),date('2017-05-31')); -- for 3 day stray readings
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
update purpleair_sl set error=1 where (device_name='SASA_PA2_SL_W' or device_name='SASA_PA2_SL_WB') and date(created_at)=date('2018-03-09'); -- removing stray readings on March 9th with 36 readings on sensor A and 37 for B
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
-- removing further stray readings
update purpleair set error=1 where device_name='SASA_PA2' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --There is a gap of 5 days after this reading
update purpleair set error=1 where device_name='SASA_PA2B' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --
update purpleair set error=1 where device_name='SASA_PA3' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); -- Gap of 4 days after this
update purpleair set error=1 where device_name='SASA_PA3B' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --
update purpleair set error=1 where device_name='SASA_PA4' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); -- Gap of 5 days
update purpleair set error=1 where device_name='SASA_PA4B' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --
update purpleair set error=1 where device_name='SASA_PA5' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); -- Gap of 5 days
update purpleair set error=1 where device_name='SASA_PA5B' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --
update purpleair set error=1 where device_name='SASA_PA6' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); -- Gap of 2 days
update purpleair set error=1 where device_name='SASA_PA6B' and season='Pilot' and community='LV' and date(created_at)=date('4/11/2017'); --
update purpleair set error=1 where device_name='SASA_PA7' and season='Pilot' and community='LV' and date(created_at)=date('4/17/2017'); -- last day reading after a gap of 5 days
update purpleair set error=1 where device_name='SASA_PA7_LV_W' and season='Winter' and community='LV' and date(created_at)=date('3/10/2018'); -- first day reading with 2 days gap
update purpleair set error=1 where device_name='SASA_PA7_LV_WB' and season='Winter' and community='LV' and date(created_at)=date('3/10/2018'); --
update purpleair set error=1 where device_name='SASA_PA7B' and season='Pilot' and community='LV' and date(created_at)=date('4/17/2017'); --
update purpleair set error=1 where device_name='SASA_PA9' and season='Pilot' and community='LV' and date(created_at)=date('4/20/2017'); --last third day reading after 8 gap
update purpleair set error=1 where device_name='SASA_PA9' and season='Pilot' and community='LV' and date(created_at)=date('5/30/2017'); --last second day reading after 39 gap and one more day reading after it
update purpleair set error=1 where device_name='SASA_PA9B' and season='Pilot' and community='LV' and date(created_at)=date('4/20/2017'); --
update purpleair set error=1 where device_name='SASA_PA9B' and season='Pilot' and community='LV' and date(created_at)=date('5/30/2017'); --
update purpleair set error=1 where device_name='SASA_PA14_NB' and season='Summer' and community='NB' and date(created_at)=date('8/29/2017'); --It is the first reading of device and Next reading after 38 days
update purpleair set error=1 where device_name='SASA_PA14_NBB' and season='Summer' and community='NB' and date(created_at)=date('8/29/2017'); --It is the first reading of device and Next reading after 37 days
update purpleair set error=1 where device_name='SASA_PA16_NB' and season='Summer' and community='NB' and date(created_at)=date('10/6/2017'); -- This device has just one day reading
update purpleair set error=1 where device_name='SASA_PA1_PC_W' and season='Winter' and community='PC' and date(created_at)=date('1/31/2018'); -- First day, next reading after 82 days
update purpleair set error=1 where device_name='SASA_PA1_PC_WB' and season='Winter' and community='PC' and date(created_at)=date('1/31/2018'); --
update purpleair set error=1 where device_name='SASA_PA10_PC_S' and season='Summer' and community='PC' and date(created_at)=date('7/27/2017'); --It is the first reading of device and Next reading after 29 days
update purpleair set error=1 where device_name='SASA_PA10_PC_S' and season='Summer' and community='PC' and date(created_at)=date('9/20/2017'); --Last reading of the device and previous reading 19 days before
update purpleair set error=1 where device_name='SASA_PA10_PC_SB' and season='Summer' and community='PC' and date(created_at)=date('7/27/2017'); --
update purpleair set error=1 where device_name='SASA_PA10_PC_SB' and season='Summer' and community='PC' and date(created_at)=date('9/20/2017'); --
update purpleair set error=1 where device_name='SASA_PA9_SE_S4' and season='Summer' and community='SE' and date(created_at)=date('8/22/2017'); -- last second day reading with a gap of 11 days
update purpleair set error=1 where device_name='SASA_PA9_SE_S4' and season='Summer' and community='SE' and date(created_at)=date('10/6/2017'); --last day reading with a gap of 44 days
update purpleair set error=1 where device_name='SASA_PA9_SE_S4B' and season='Summer' and community='SE' and date(created_at)=date('8/22/2017'); --
update purpleair set error=1 where device_name='SASA_PA9_SE_S4B' and season='Summer' and community='SE' and date(created_at)=date('10/6/2017'); --
update purpleair set error=1 where device_name='SASA_PA13_SL_S' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); --It is the first reading of device and Next reading after 24 days
update purpleair set error=1 where device_name='SASA_PA13_SL_SB' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); --
update purpleair set error=1 where device_name='SASA_PA15_SL_S' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); -- It is the first reading of device and Next reading after 28 days
update purpleair set error=1 where device_name='SASA_PA15_SL_SB' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); --
update purpleair set error=1 where device_name='SASA_PA16_SL_S' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); -- First day, next reading after 22 days
update purpleair set error=1 where device_name='SASA_PA16_SL_SB' and season='Summer' and community='SL' and date(created_at)=date('8/29/2017'); --
update purpleair set error=1 where device_name='SASA_PA2_SL_W' and season='Winter' and community='SL' and date(created_at)=date('3/9/2018'); -- First reading and next reading after 42 days
update purpleair set error=1 where device_name='SASA_PA2_SL_WB' and season='Winter' and community='SL' and date(created_at)=date('3/9/2018'); -- First reading and next reading after 42 days
update purpleair set error=1 where device_name='SASA_PA6_SL_SB' and season='Summer' and community='SL' and date(created_at)=date('10/6/2017'); -- Last readings after a gap of 2 days
update purpleair_sl set error=1 where device_name='SASA_PA16_SL_S' and community='SL' and created_at>='2017-10-03 06:00:00'; -- removing stray readings for last few hour due to other sensors high reading
update purpleair_sl set error=1 where device_name='SASA_PA16_SL_SB' and community='SL' and created_at>='2017-10-03 06:00:00'; -- removing stray readings for last few hour due to other sensors high reading
update purpleair_sl set error=1 where date(created_at)<=date('2017-09-26') and device_name='SASA_PA3_SL_S'; -- remove stray readings as reading from sensor A and sensor B vary more than threshold
update purpleair_sl set error=1 where device_name='SASA_PA3_SL_S' and community='SL' and created_at>='2017-10-02 02:30:00';
update purpleair_sl set error=1 where date(created_at)<=date('2017-09-26') and device_name='SASA_PA3_SL_SB';
update purpleair_sl set error=1 where device_name='SASA_PA3_SL_SB' and community='SL' and created_at>='2017-10-02 02:30:00';
update purpleair_lv set error=1 where device_name='SASA_PA4' and date(created_at)<=date('2017-04-17'); -- removing one day stray reading
update purpleair_lv set error=1 where device_name='SASA_PA4B' and date(created_at)<=date('2017-04-17'); -- removing one day stray reading
update purpleair set error=1 where device_name='SASA_PA4_LV_W' and date(created_at)<=date('2018-03-11'); -- few readings and has a gap in the begninning
update purpleair set error=1 where device_name='SASA_PA4_LV_WB' and date(created_at)<=date('2018-03-11'); -- few readings and has a gap in the begninning
