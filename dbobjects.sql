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

-- functions
-- List of unique sensors
-- '{"SASA_PA10","SASA_PA10_PC_S","SASA_PA10_SL_S","SASA_PA13_SL_S","SASA_PA14_NB","SASA_PA15_SL_S","SASA_PA16_NB","SASA_PA16_SL_S","SASA_PA1_LV_W","SASA_PA1_PC_S","SASA_PA1_PC_W","SASA_PA2","SASA_PA2_LV_S","SASA_PA2_LV_W","SASA_PA2_PC_S","SASA_PA2_SE_S2","SASA_PA2_SL_W","SASA_PA3","SASA_PA3_LV_S","SASA_PA3_LV_W","SASA_PA3_PC_S","SASA_PA3_SL_S","SASA_PA3_SL_W","SASA_PA4","SASA_PA4_LV_S","SASA_PA4_LV_W","SASA_PA4_SL_W","SASA_PA5","SASA_PA5_LV_S","SASA_PA5_LV_W","SASA_PA5_SL_W","SASA_PA6","SASA_PA6_LV_S","SASA_PA6_LV_W","SASA_PA6_NB","SASA_PA6_SE_S6","SASA_PA6_SL_S","SASA_PA6_SL_W","SASA_PA7","SASA_PA7_LV_S","SASA_PA7_LV_W","SASA_PA7_SE_S3","SASA_PA7_SE_W","SASA_PA8","SASA_PA8_LV_S","SASA_PA9","SASA_PA9_NB","SASA_PA9_SE_S4"}'
CREATE OR REPLACE FUNCTION clean_purpleairprimary(varchar) RETURNS void AS $$
DECLARE
devices varchar[]:= $1;
name varchar;
eminute record;
begin
foreach name in array devices loop
	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleairprimary where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleairprimary where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
		update purpleairprimary set error='1' where created_at between eminute.val and eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleairprimary where created_at between eminute.val and eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
	end loop;
end loop;
END;
$$ LANGUAGE 'plpgsql' STRICT;
