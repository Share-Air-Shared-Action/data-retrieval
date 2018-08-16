-- tables
CREATE TABLE wundergound (
    observation_time timestamptz UNIQUE NOT NULL,
    temp_f double precision,
    relative_humidity double precision,
    wind_dir text,
    wind_degrees double precision,
    wind_mph double precision,
    wind_gust_mph double precision,
    pressure_in double precision,
    pressure_trend char,
    dewpoint_f double precision,
    heat_index_f double precision,
    windchill_f double precision,
    feelslike_f double precision,
    visibility_mi double precision,
    solarradiation double precision,
    UV double precision,
    precip_1hr_in double precision,
    precip_today_in double precision,
    observation_lat float,
    observation_lng float,
    community varchar(2)
);

create table purpleairprimary_log(
  device_name varchar(20) NOT NULL,
  start_time timestamp with time zone,
  end_time timestamp with time zone,
  rows_affected integer
);

create table purpleair(
	 created_at        timestamp with time zone,
	 entry_id          integer,
	 pm1_cf_atm_ugm3   double precision,
	 pm25_cf_atm_ugm3  double precision,
	 pm10_cf_atm_ugm3  double precision,
	 uptimeminutes     numeric,
	 rssi_dbm          numeric,
	 temperature_f     double precision ,
	 humidity_percent  numeric,
	 pm25_cf_1_ugm3    double precision,
	 device_name       character varying(20),
	 season            character varying(20),
	 error             integer,
	 community         character varying(2)
 );

-- using partition table on purpleair table

CREATE TABLE purpleair_SL (
    CHECK ( community='SL' )
) INHERITS (purpleair);
CREATE TABLE purpleair_SE (
    CHECK ( community='SE' )
) INHERITS (purpleair);
CREATE TABLE purpleair_NB (
    CHECK ( community='NB' )
) INHERITS (purpleair);
CREATE TABLE purpleair_PC (
    CHECK ( community='PC' )
) INHERITS (purpleair);
CREATE TABLE purpleair_LV (
    CHECK ( community='LV' )
) INHERITS (purpleair);

-- insert trigger on purpleair table
CREATE TRIGGER insert_purpleair_trigger
    BEFORE INSERT ON purpleair
    FOR EACH ROW EXECUTE PROCEDURE purpleair_insert_trigger();

CREATE OR REPLACE FUNCTION purpleair_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.community = 'SL' ) THEN
        INSERT INTO purpleair_SL VALUES (NEW.*);
    ELSIF ( NEW.community = 'SE' ) THEN
        INSERT INTO purpleair_SE VALUES (NEW.*);
    ELSIF ( NEW.community = 'NB' ) THEN
        INSERT INTO purpleair_NB VALUES (NEW.*);
	ELSIF ( NEW.community = 'PC' ) THEN
        INSERT INTO purpleair_PC VALUES (NEW.*);
    ELSIF ( NEW.community = 'LV' ) THEN
        INSERT INTO purpleair_LV VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

--loading data into each table using purpleairsecondary
insert into purpleair_sl select * from purpleairsecondary where community='SL';
insert into purpleair_se select * from purpleairsecondary where community='SE';
insert into purpleair_nb select * from purpleairsecondary where community='NB';
insert into purpleair_pc select * from purpleairsecondary where community='PC';
insert into purpleair_lv select * from purpleairsecondary where community='LV';

create index on purpleair(community,season,device_name);

-- functions
-- List of unique sensors
-- '{"SASA_PA10","SASA_PA10_PC_S","SASA_PA10_SL_S","SASA_PA13_SL_S","SASA_PA14_NB","SASA_PA15_SL_S","SASA_PA16_NB","SASA_PA16_SL_S","SASA_PA1_LV_W","SASA_PA1_PC_S","SASA_PA1_PC_W","SASA_PA2","SASA_PA2_LV_S","SASA_PA2_LV_W","SASA_PA2_PC_S","SASA_PA2_SE_S2","SASA_PA2_SL_W","SASA_PA3","SASA_PA3_LV_S","SASA_PA3_LV_W","SASA_PA3_PC_S","SASA_PA3_SL_S","SASA_PA3_SL_W","SASA_PA4","SASA_PA4_LV_S","SASA_PA4_LV_W","SASA_PA4_SL_W","SASA_PA5","SASA_PA5_LV_S","SASA_PA5_LV_W","SASA_PA5_SL_W","SASA_PA6","SASA_PA6_LV_S","SASA_PA6_LV_W","SASA_PA6_NB","SASA_PA6_SE_S6","SASA_PA6_SL_S","SASA_PA6_SL_W","SASA_PA7","SASA_PA7_LV_S","SASA_PA7_LV_W","SASA_PA7_SE_S3","SASA_PA7_SE_W","SASA_PA8","SASA_PA8_LV_S","SASA_PA9","SASA_PA9_NB","SASA_PA9_SE_S4"}'
CREATE OR REPLACE FUNCTION clean_purpleairprimary() RETURNS void AS $$
  DECLARE
  devices_sl varchar[]:= '{"SASA_PA10_SL_S","SASA_PA13_SL_S","SASA_PA2_SL_W","SASA_PA3_SL_S","SASA_PA3_SL_W","SASA_PA4_SL_W","SASA_PA6_SL_S","SASA_PA6_SL_W","SASA_PA15_SL_S","SASA_PA16_SL_S","SASA_PA10","SASA_PA2","SASA_PA3","SASA_PA4","SASA_PA5","SASA_PA6","SASA_PA7","SASA_PA8","SASA_PA9"}';
  devices_pc varchar[]:= '{"SASA_PA10_PC_S","SASA_PA1_PC_S","SASA_PA1_PC_W","SASA_PA2_PC_S","SASA_PA3_PC_S"}';
  devices_nb varchar[]:= '{"SASA_PA14_NB","SASA_PA16_NB","SASA_PA6_NB","SASA_PA9_NB"}';
  devices_lv varchar[]:= '{"SASA_PA1_LV_W","SASA_PA2_LV_W","SASA_PA3_LV_S","SASA_PA3_LV_W","SASA_PA5_LV_S","SASA_PA5_LV_W","SASA_PA6_LV_S","SASA_PA6_LV_W","SASA_PA7_LV_S","SASA_PA7_LV_W","SASA_PA8_LV_S","SASA_PA4_LV_S","SASA_PA4_LV_W","SASA_PA2_LV_S"}';
  devices_se varchar[]:= '{"SASA_PA2_SE_S2","SASA_PA5_SL_W","SASA_PA7_SE_S3","SASA_PA7_SE_W","SASA_PA9_SE_S4","SASA_PA6_SE_S6"}';
  name varchar;
  eminute record;
  begin

  -- cleaning sl data
  foreach name in array devices_sl loop
  	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_sl where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_sl where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
  		update purpleair_sl set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
  		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
  		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_sl where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
  	end loop;
  end loop;

  -- cleaning se data
  foreach name in array devices_se loop
  	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_se where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_se where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
  		update purpleair_se set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
  		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
  		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_se where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
  	end loop;
  end loop;

  -- cleaning nb data
  foreach name in array devices_nb loop
  	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_nb where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_nb where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
  		update purpleair_nb set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
  		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
  		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_nb where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
  	end loop;
  end loop;

  -- cleaning pc data
  foreach name in array devices_pc loop
  	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_pc where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_pc where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
  		update purpleair_pc set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
  		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
  		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_pc where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
  	end loop;
  end loop;

  -- cleaning lv data
  foreach name in array devices_lv loop
  	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_lv where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
  	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_lv where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
  		update purpleair_lv set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
  		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
  		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_lv where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
  	end loop;
  end loop;

  END;
$$ LANGUAGE 'plpgsql' STRICT;

drop table if exists aeroqualno2_15min;
drop table if exists aeroqualo3_15min;
drop table if exists purpleair_15min;
drop table if exists metone_15min;
drop table if exists aeroqualno2_1hr;
drop table if exists aeroqualno2_1hr;
drop table if exists purpleair_1hr;
drop table if exists metone_1hr;
drop table if exists metone_24hr;

-- 15min averages from the raw tables with the good readings (error!=1) equal or greater than 75%
create table aeroqualno2_15min	as
select date_trunc('hour', date) + date_part('minute', date)::int / 15 * interval '15 min' AS date, monitorid, locationid, avg(case when flag is null then no2ppm end) AS no2ppm_avg, unit_id, season, community,sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from aeroqualno2 where flag is distinct from 90 group by 1, monitorid, locationid, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

create table aeroqualo3_15min	as
select date_trunc('hour', date) + date_part('minute', date)::int / 15 * interval '15 min' AS date, monitorid, locationid, avg(case when flag is null then o3ppm end) AS o3ppm_avg, unit_id, season, community,sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from aeroqualo3 where flag is distinct from 90 group by 1, monitorid, locationid, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

-- metone not many reading, it is just three or less
create table metone_15min	as
select date_trunc('hour', time) + date_part('minute', time)::int / 15 * interval '15 min' AS time, type, avg(case when flag is null then value end) AS value_avg, unit_id, device, season, community,sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from metone where flag is distinct from 90 group by 1, type, unit_id, device, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

-- no partitioned table for purpleair_15min
create table purpleair_15min as
select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 15 * interval '15 min' AS created_at, avg(case when flag is null then pm1_cf_atm_ugm3 end) AS pm1_cf_atm_ugm3_avg, avg(case when flag is null then pm25_cf_atm_ugm3 end) AS pm25_cf_atm_ugm3_avg, avg(case when flag is null then pm10_cf_atm_ugm3 end) AS pm10_cf_atm_ugm3_avg, avg(uptimeminutes) uptimeminutes_avg, avg(rssi_dbm) rssi_dbm_avg, avg(temperature_f) temperature_f_avg, avg(pm25_cf_1_ugm3) pm25_cf_1_ugm3_avg, device_name, season, community, sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from purpleair group by 1, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

-- 1 hour averages from the raw tables with the good readings (error!=1) equal or greater than 75%
drop table if exists aeroqualno2_1hr;
create table aeroqualno2_1hr	as
select date_trunc('hour', date) + date_part('minute', date)::int / 60 * interval '60 min' AS date, monitorid, locationid, avg(no2ppm) AS no2ppm_avg, unit_id, season, community,sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from aeroqualno2 where flag is distinct from 90 group by 1, monitorid, locationid, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

drop table if exists aeroqualo3_1hr;
create table aeroqualo3_1hr	as
select date_trunc('hour', date) + date_part('minute', date)::int / 60 * interval '60 min' AS date, monitorid, locationid, avg(o3ppm) AS o3ppm_avg, unit_id, season, community,sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from aeroqualo3 where flag is distinct from 90 group by 1, monitorid, locationid, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

-- metone not many reading, it is just three or less
drop table if exists metone_1hr;
create table metone_1hr	as
select date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min' AS time, type, avg(value) AS avg_value, max(value) AS max_value, min(value) AS min_value,unit_id, device, season, community,sum(case when error is null then 1 else 0 end) AS no_of_readings from metone where flag is distinct from 90 group by 1, type, unit_id, device, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;
drop table if exists metone_24hr;
create table metone_24hr	as
select date(time) AS time, type, avg(value) AS avg_value, max(value) AS max_value, min(value) AS min_value,unit_id, device, season, community,sum(case when error is null then 1 else 0 end) AS no_of_readings from metone where flag is distinct from 90 group by 1, type, unit_id, device, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;

-- no partitioned table for purpleair_1hr
drop table if exists purpleair_1hr;
create table purpleair_1hr as
select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 60 * interval '60 min' AS created_at, avg(pm1_cf_atm_ugm3) AS pm1_cf_atm_ugm3_avg, avg(pm25_cf_atm_ugm3) AS pm25_cf_atm_ugm3_avg, avg(pm10_cf_atm_ugm3) AS pm10_cf_atm_ugm3_avg, avg(uptimeminutes) uptimeminutes_avg, avg(rssi_dbm) rssi_dbm_avg, avg(temperature_f) temperature_f_avg, avg(pm25_cf_1_ugm3) pm25_cf_1_ugm3_avg, device_name, season, community, sum(case when flag is distinct from 90 then 1 else 0 end) AS no_of_readings from purpleair group by 1, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by 1;


-- weather summer data
create table weather_summer(
  site varchar(10),
  latitude  double precision,
  longitude double precision,
  date_time_gmt timestamp with time zone,
  date_time_local timestamp with time zone,
  mean_2m_temp_f double precision,
  dewpt_temp_f double precision,
  wet_bulb_temp_f double precision,
  rh_percent double precision,
  sfc_press_mb double precision,
  wind_speed_10m_mph double precision,
  wind_dir_deg double precision,
  cloud_coverage_percent double precision,
  prev_hour_precip_in double precision,
  direct_normal_irrad_wm2 double precision,
  downward_solar_rad_wm2 double precision,
  diffuse_horiz_rad_wm2 double precision,
  wind_chill_f double precision,
  apparent_temp_f double precision,
  heat_index_f double precision,
  snowfall_in double precision,
  mslp_mb double precision,
  wind_gusts_mph double precision,
community character varying(2));

-- loading summer weather data from csv files
truncate table weather_summer;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,wind_speed_10m_mph,wind_dir_deg,cloud_coverage_percent,prev_hour_precip_in,direct_normal_irrad_wm2,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,wind_chill_f,apparent_temp_f,heat_index_f,snowfall_in,mslp_mb,wind_gusts_mph) FROM '/home/v/vijayv/summer_weather_data/41.845_-87.705HistoricalData.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,wind_speed_10m_mph,wind_dir_deg,cloud_coverage_percent,prev_hour_precip_in,direct_normal_irrad_wm2,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,wind_chill_f,apparent_temp_f,heat_index_f,snowfall_in,mslp_mb,wind_gusts_mph) FROM '/home/v/vijayv/summer_weather_data/41.858_-87.620HistoricalData.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,wind_speed_10m_mph,wind_dir_deg,cloud_coverage_percent,prev_hour_precip_in,direct_normal_irrad_wm2,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,wind_chill_f,apparent_temp_f,heat_index_f,snowfall_in,mslp_mb,wind_gusts_mph) FROM '/home/v/vijayv/summer_weather_data/41.692_-87.533HistoricalData.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,wind_speed_10m_mph,wind_dir_deg,cloud_coverage_percent,prev_hour_precip_in,direct_normal_irrad_wm2,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,wind_chill_f,apparent_temp_f,heat_index_f,snowfall_in,mslp_mb,wind_gusts_mph) FROM '/home/v/vijayv/summer_weather_data/42.159_-87.776HistoricalData.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,wind_speed_10m_mph,wind_dir_deg,cloud_coverage_percent,prev_hour_precip_in,direct_normal_irrad_wm2,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,wind_chill_f,apparent_temp_f,heat_index_f,snowfall_in,mslp_mb,wind_gusts_mph) FROM '/home/v/vijayv/summer_weather_data/41.845_-87.705HistoricalData.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/LV_7012017to8102017_41.844673_-87.705058.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/SL_9082017to9182017_41.858498_-87.619919.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/SE_8092017to8102017_41.691509_-87.533386.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/SE_7132017to7152017_41.691509_-87.533386.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/PC_8112017to8122017_41.656588_-87.6.csv' DELIMITER ',' CSV HEADER;
\COPY weather_summer(site,latitude,longitude,date_time_gmt,date_time_local,mean_2m_temp_f,dewpt_temp_f,wet_bulb_temp_f,rh_percent,sfc_press_mb,cloud_coverage_percent,wind_chill_f,apparent_temp_f,wind_speed_10m_mph,wind_dir_deg,prev_hour_precip_in,downward_solar_rad_wm2,diffuse_horiz_rad_wm2,direct_normal_irrad_wm2,mslp_mb,heat_index_f,snowfall_in,wind_gusts_mph,community) FROM '/home/v/vijayv/summer_weather_data/LV_4122017to5302017_41.844673_-87.705058.csv' DELIMITER ',' CSV HEADER;

-- update community based on lat long
update weather_summer set community='PC' where latitude=41.657 and longitude=-87.600;
update weather_summer set community='SL' where latitude=41.858 and longitude=-87.620;
update weather_summer set community='SE' where latitude=41.692 and longitude=-87.533;
update weather_summer set community='NB' where latitude=42.159 and longitude=-87.776;
update weather_summer set community='LV' where latitude=41.845 and longitude=-87.705;


-- load the data into wundergound converting the pressure from mb to in
delete from wundergound where date(observation_time)<=date('2017-12-10');
insert into wundergound(observation_time,temp_f, wind_degrees,wind_mph,wind_gust_mph,pressure_in,dewpoint_f,heat_index_f,windchill_f,solarradiation,precip_1hr_in,observation_lat,observation_lng,community,relative_humidity) select distinct date_time_gmt at time zone 'utc' at time zone 'america/chicago',mean_2m_temp_f,wind_dir_deg,wind_speed_10m_mph,wind_gusts_mph,sfc_press_mb*0.02953,dewpt_temp_f,heat_index_f,wind_chill_f,downward_solar_rad_wm2,prev_hour_precip_in,latitude,longitude,community ,rh_percent from weather_summer;
// where not exists (select 1 from wundergound where observation_time=date_time_gmt at time zone 'utc' at time zone 'america/chicago' and community=weather_summer_new.community);

delete from wundergound where date(observation_time)>=date('2017-07-13') and date(observation_time)<=date('2017-07-16') and community='SE';
delete from wundergound where date(observation_time)>=date('2017-08-09') and date(observation_time)<=date('2017-08-11') and community='SE';
delete from wundergound where date(observation_time)>=date('2017-08-11') and date(observation_time)<=date('2017-08-13') and community='PC';
delete from wundergound where date(observation_time)>=date('2017-09-08') and date(observation_time)<=date('2017-09-19') and community='SL';
delete from wundergound where date(observation_time)>=date('2017-04-12') and date(observation_time)<=date('2017-05-30') and community='LV';
delete from wundergound where date(observation_time)>=date('2017-04-12') and date(observation_time)<=date('2017-08-11') and community='LV';

LV_4122017to5302017_41.844673_-87.705058.csv
LV_7012017to8102017_41.844673_-87.705058.csv
PC_8112017to8122017_41.656588_-87.6.csv
SE_7132017to7152017_41.691509_-87.533386.csv
SE_8092017to8102017_41.691509_-87.533386.csv
SL_9082017to9182017_41.858498_-87.619919.csv


select from wundergound where observation_time=
