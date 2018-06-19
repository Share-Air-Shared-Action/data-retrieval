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

-- functions
-- List of unique sensors
-- '{"SASA_PA10","SASA_PA10_PC_S","SASA_PA10_SL_S","SASA_PA13_SL_S","SASA_PA14_NB","SASA_PA15_SL_S","SASA_PA16_NB","SASA_PA16_SL_S","SASA_PA1_LV_W","SASA_PA1_PC_S","SASA_PA1_PC_W","SASA_PA2","SASA_PA2_LV_S","SASA_PA2_LV_W","SASA_PA2_PC_S","SASA_PA2_SE_S2","SASA_PA2_SL_W","SASA_PA3","SASA_PA3_LV_S","SASA_PA3_LV_W","SASA_PA3_PC_S","SASA_PA3_SL_S","SASA_PA3_SL_W","SASA_PA4","SASA_PA4_LV_S","SASA_PA4_LV_W","SASA_PA4_SL_W","SASA_PA5","SASA_PA5_LV_S","SASA_PA5_LV_W","SASA_PA5_SL_W","SASA_PA6","SASA_PA6_LV_S","SASA_PA6_LV_W","SASA_PA6_NB","SASA_PA6_SE_S6","SASA_PA6_SL_S","SASA_PA6_SL_W","SASA_PA7","SASA_PA7_LV_S","SASA_PA7_LV_W","SASA_PA7_SE_S3","SASA_PA7_SE_W","SASA_PA8","SASA_PA8_LV_S","SASA_PA9","SASA_PA9_NB","SASA_PA9_SE_S4"}'
CREATE OR REPLACE FUNCTION clean_purpleairprimary() RETURNS void AS $$
DECLARE
devices varchar[]:= $1;
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
foreach name in array devices_sl loop
	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_se where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_se where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
		update purpleair_se set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_se where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
	end loop;
end loop;

-- cleaning nb data
foreach name in array devices_sl loop
	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_nb where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_nb where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
		update purpleair_nb set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_nb where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
	end loop;
end loop;

-- cleaning pc data
foreach name in array devices_sl loop
	for eminute in select at2.minutes as val from (select att.minutes, case when sensora>1000 OR sensorb>1000 OR sensora=0 or sensorb=0 or (abs(sensora - sensorb)>=4 AND (sensora/sensorb >= 2 OR sensorb/sensora >= 2) ) then 'true' else 'false' end as can_update from (select sensora.minutes,coalesce(sensora.avg, 0) sensora,coalesce(sensorb.avg, 0) sensorb from
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_pc where device_name=name and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensora full join
	(select date_trunc('hour', created_at) + date_part('minute', created_at)::int / 5 * interval '5 min' AS minutes,avg(pm25_cf_atm_ugm3) avg from purpleair_pc where device_name=name||'B'	and error is distinct from 1 and created_at > '2017-06-05 00:00:00-05' group by 1) sensorb on sensora.minutes=sensorb.minutes) att) at2 where can_update='true' loop
		update purpleair_pc set error='1' where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B';
		INSERT INTO purpleairprimary_log (device_name, start_time, end_time, rows_affected, log_time)
		select device_name, eminute.val, eminute.val + interval '5 minutes', count(*), current_timestamp from purpleair_pc where created_at > eminute.val and created_at < eminute.val + interval '5 minutes' and device_name=name or device_name=name||'B' group by device_name;
	end loop;
end loop;

-- cleaning lv data
foreach name in array devices_sl loop
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
