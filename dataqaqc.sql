/* Create flag_lookup with the listing all the flag used along with its description */
drop table if exists flag_lookup;
create table flag_lookup(
  flag integer,
  description character varying(500),
  type character varying(15)
);
\copy flag_lookup from flag_lookup.csv (format csv,header)

/* Creating a database_table_lookup for lookup information of the relevant tables in database */
drop table if exists database_table_lookup;
create table database_table_lookup(
  table_name character varying(32),
  table_description character varying(1000),
  type character varying(30)
);
\copy database_table_lookup from database_table_lookup.csv (format csv,header)


/* 2.	Data Gathering – Consolidate air quality and meteorological data into the SASA database */
/* b.	Obtain hourly values of PM2.5, PM10, NO/NOx/NO2, CO, and ozone data from a regulatory monitoring station closest to each community. Hourly values can be easily obtained from EPA’s Air Data system (https://www.epa.gov/outdoor-air-quality-data). The “Monitor Locations” map can help with identifying nearby monitoring sites. Files with hourly data for these sites can be obtained from either the “Pre-generated Data Files” or ‘Download Raw Data” web pages. The hourly pre-generated files contain data for all monitors in the country, which can be filtered for the locations of interest after download.
c.	Obtain 24-hour averages for all pollutants and maximum 8-hour ozone values. */
/*Table creation for loading daily, hourly and 8hourly data */
drop table if exists epa_daily_o3;
create table epa_daily_o3(
  state_code  integer,
  county_code integer,
  site_num integer,
  parameter_code integer,
  poc integer,
  latitude double precision,
  longitude double precision,
  datum character varying(50),
  parameter_name character varying(50),
  sample_duration character varying(50),
  pollutant_standard character varying(50),
  date_local date,
  units_of_measure character varying(50),
  event_type character varying(50),
  observation_count integer,
  observation_percent double precision,
  arithmetic_mean double precision,
  first_max_value  double precision,
  first_max_hour integer,
  aqi character varying(5),
  method_code character varying(50),
  method_name character varying(100),
  local_site_name character varying(200),
  address character varying(200),
  state_name character varying(50),
  county_name character varying(50),
  city_name character varying(50),
  cbsa_name character varying(50),
date_of_last_change date);


drop table if exists epa_hourly_o3;
create table epa_hourly_o3(
  state_code integer,
  county_code integer,
  site_num integer,
  parameter_code integer,
  poc integer,
  latitude double precision,
  longitude double precision,
  datum character varying(50),
  parameter_name character varying(50),
  date_local date,
  time_local time,
  date_gmt date,
  time_gmt time,
  sample_measurement double precision,
  units_of_measure character varying(50),
  mdl double precision,
  uncertainty character varying(50),
  qualifier character varying(50),
  method_type character varying(50),
  method_code integer,
  method_name character varying(100),
  state_name character varying(50),
  county_name character varying(50),
date_of_last_change date);

drop table if exists epa_8hour_o3;
create table epa_8hour_o3(
  state_code integer,
  county_code integer,
  site_num integer,
  parameter_code integer,
  poc integer,
  latitude double precision,
  longitude double precision,
  datum character varying(100),
  parameter_name character varying(100),
  date_local date,
  time_local time,
  date_gmt date,
  time_gmt time,
  sample_duration character varying(100),
  pollutant_standard character varying(100),
  units_of_measure character varying(100),
  observation_count integer,
  observations_with_events integer,
  null_observations integer,
  mean_including_all_data double precision,
  mean_excluding_all_flagged_data double precision,
  mean_excluding_concurred_flags double precision,
  date_of_last_change date
);


/* Create remaining table from the base table */
drop table if exists epa_daily_no2; create table epa_daily_no2 as select * from epa_daily_o3 where 1=0;
drop table if exists epa_daily_pm25; create table epa_daily_pm25 as select * from epa_daily_o3 where 1=0;
drop table if exists epa_daily_pm10; create table epa_daily_pm10 as select * from epa_daily_o3 where 1=0;
drop table if exists epa_daily_co; create table epa_daily_co as select * from epa_daily_o3 where 1=0;
drop table if exists epa_hourly_no2; create table epa_hourly_no2 as select * from epa_hourly_o3 where 1=0;
drop table if exists epa_hourly_pm25; create table epa_hourly_pm25 as select * from epa_hourly_o3 where 1=0;
drop table if exists epa_hourly_pm10; create table epa_hourly_pm10 as select * from epa_hourly_o3 where 1=0;
drop table if exists epa_hourly_co; create table epa_hourly_co as select * from epa_hourly_o3 where 1=0;

/* truncate table statement if needed to be repopulated */
truncate table epa_daily_o3;
truncate table epa_daily_no2;
truncate table epa_daily_pm25;
truncate table epa_daily_pm10;
truncate table epa_daily_co;
truncate table epa_hourly_o3;
truncate table epa_hourly_no2;
truncate table epa_hourly_pm25;
truncate table epa_hourly_pm10;
truncate table epa_hourly_co;


/* Back up of the summary table */
\copy epa_hourly_co(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'co/hourly_42101_2017.csv' delimiter ',' csv header;
\copy epa_hourly_co(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'co/hourly_42101_2018.csv' delimiter ',' csv header;
\copy epa_daily_co(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'co/daily_42101_2017.csv' delimiter ',' csv header;
\copy epa_daily_co(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'co/daily_42101_2018.csv' delimiter ',' csv header;
\copy epa_hourly_no2(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'no2/hourly_42602_2017.csv' delimiter ',' csv header;
\copy epa_hourly_no2(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'no2/hourly_42602_2018.csv' delimiter ',' csv header;
\copy epa_daily_no2(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'no2/daily_42602_2017.csv' delimiter ',' csv header;
\copy epa_daily_no2(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'no2/daily_42602_2018.csv' delimiter ',' csv header;
\copy epa_hourly_o3(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'o3/hourly_44201_2017.csv' delimiter ',' csv header;
\copy epa_hourly_o3(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'o3/hourly_44201_2018.csv' delimiter ',' csv header;
\copy epa_daily_o3(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'o3/daily_44201_2017.csv' delimiter ',' csv header;
\copy epa_daily_o3(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'o3/daily_44201_2018.csv' delimiter ',' csv header;
/* \copy epa_8hour_o3(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_duration,pollutant_standard,units_of_measure,observation_count,observations_with_events,null_observations,mean_including_all_data,mean_excluding_all_flagged_data,mean_excluding_concurred_flags,date_of_last_change)  from '8hour_44201_2017.csv' delimiter ',' csv header;
\copy epa_8hour_o3(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_duration,pollutant_standard,units_of_measure,observation_count,observations_with_events,null_observations,mean_including_all_data,mean_excluding_all_flagged_data,mean_excluding_concurred_flags,date_of_last_change)  from '8hour_44201_2018.csv' delimiter ',' csv header; */
\copy epa_hourly_pm10(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'SASA/pm10/hourly_81102_2017.csv' delimiter ',' csv header;
\copy epa_hourly_pm10(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'SASA/pm10/hourly_81102_2018.csv' delimiter ',' csv header;
\copy epa_daily_pm10(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'pm10/daily_81102_2017.csv' delimiter ',' csv header;
\copy epa_daily_pm10(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'pm10/daily_81102_2018.csv' delimiter ',' csv header;
\copy epa_hourly_pm25(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'SASA/pm25/hourly_88101_2017.csv' delimiter ',' csv header;
\copy epa_hourly_pm25(state_code,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,date_local,time_local,date_gmt,time_gmt,sample_measurement,units_of_measure,mdl,uncertainty,qualifier,method_type,method_code,method_name,state_name,county_name,date_of_last_change)  from 'SASA/pm25/hourly_88101_2018.csv' delimiter ',' csv header;
\copy epa_daily_pm25(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'pm25/daily_88101_2017.csv' delimiter ',' csv header;
\copy epa_daily_pm25(state_code ,county_code,site_num,parameter_code,poc,latitude,longitude,datum,parameter_name,sample_duration,pollutant_standard,date_local,units_of_measure,event_type,observation_count,observation_percent,arithmetic_mean,first_max_value,first_max_hour,aqi,method_code,method_name,local_site_name,address,state_name,county_name,city_name,cbsa_name,date_of_last_change) from 'pm25/daily_88101_2018.csv' delimiter ',' csv header;

truncate table epa_daily_co;
truncate table epa_daily_no2;
truncate table epa_daily_o3;
truncate table epa_daily_pm10;
truncate table epa_daily_pm25;
truncate table epa_hourly_co;
truncate table epa_hourly_no2;
truncate table epa_hourly_o3;
truncate table epa_hourly_pm10;
truncate table epa_hourly_pm25;
/* truncate table epa_8hour_o3; */

/* Identifying the shortest distance between two location using  the formula: sqrt(power((x1-x2),2)+power((y1-y2),2)) */
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, local_site_name,address,city_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,local_site_name,address,city_name from epa_daily_o3) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_daily_o3.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, local_site_name,address,city_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,local_site_name,address,city_name from epa_daily_co) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.4 order by 1, a.community) to 'shortest_dist_daily_co.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, local_site_name,address,city_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,local_site_name,address,city_name from epa_daily_no2) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_daily_no2.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, local_site_name,address,city_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,local_site_name,address,city_name from epa_daily_pm10) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_daily_pm10.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, local_site_name,address,city_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,local_site_name,address,city_name from epa_daily_pm25) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_daily_pm25.csv' delimiter ',' csv;

\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_name,county_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_name,county_name from epa_hourly_o3) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_hourly_o3.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_name,county_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_name,county_name from epa_hourly_co) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.4 order by 1, a.community) to 'shortest_dist_hourly_co.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_name,county_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_name,county_name from epa_hourly_no2) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_hourly_no2.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_name,county_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_name,county_name from epa_hourly_pm10) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_hourly_pm10.csv' delimiter ',' csv;
\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_name,county_name from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_name,county_name from epa_hourly_pm25) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_hourly_pm25.csv' delimiter ',' csv;

\copy (select SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2)) as distinace, a.latitude, a.longitude, a.community, b.latitude,b.longitude, site_num,state_code,county_code from ( SELECT AVG(latitude) AS latitude, AVG(longitude) AS longitude, community FROM (SELECT latitude, longitude,UPPER(SUBSTRING(session_title, 1, 2)) AS community FROM airterrier where UPPER(SUBSTRING(session_title, 1, 2)) in ('SL','PC','AG','SE','NB','LV') UNION ALL SELECT latitude, longitude, community FROM stationarylocations) AS centers group by community) a, (select distinct latitude,longitude,site_num,state_code,county_code from epa_8hour_o3) as b where SQRT(POWER(ABS(a.latitude-b.latitude),2)+POWER(ABS(a.longitude-b.longitude),2))<0.3 order by 1, a.community) to 'shortest_dist_8hour_o3.csv' delimiter ',' csv;

delete from epa_hourly_no2 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='no2' group by 1);
delete from epa_hourly_o3 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='o3' group by 1);
delete from epa_hourly_co where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='co' group by 1);
delete from epa_hourly_pm10 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='pm10' group by 1);
delete from epa_hourly_pm25 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='pm2.5' group by 1);
delete from epa_daily_no2 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='no2' group by 1);
delete from epa_daily_o3 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='o3' group by 1);
delete from epa_daily_co where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='co' group by 1);
delete from epa_daily_pm10 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='pm10' group by 1);
delete from epa_daily_pm25 where latitude::varchar||longitude::varchar not in (select latitude::varchar||longitude::varchar from epa_sensors_community_lookup where pollutant='pm2.5' group by 1);

/* Remove the sensor location readings that are other than the closest one */
delete from epa_daily_co where latitude not in (42.139996,41.629073) and longitude not in (-87.799227,-87.461554);
delete from epa_daily_no2 where latitude not in (41.877682,41.855243,41.7514,41.965193,41.877682) and longitude not in (-87.635027,-87.75247,-87.75247,-87.713488,-87.635027);
delete from epa_daily_o3 where latitude not in (42.139996,41.855243,41.755832,41.639444,41.855243) and longitude not in (-87.799227,-87.75247,-87.54535,-87.493611,-87.75247);
delete from epa_daily_pm10 where latitude not in (42.139996,41.687165,41.687165,41.80118,41.687165) and longitude not in (-87.799227,-87.539315,-87.539315,-87.832349,-87.539315);
delete from epa_daily_pm25 where latitude not in (42.139996,41.687165,41.864426,41.687165,41.912739) and longitude not in (-87.799227,-87.539315,-87.748902,-87.539315,-87.722673);
delete from epa_hourly_co where latitude not in (42.139996,41.629073) and longitude not in (-87.799227,-87.461554);
delete from epa_hourly_no2 where latitude not in (41.877682,41.855243,41.7514,41.965193,41.877682) and longitude not in (-87.635027,-87.75247,-87.75247,-87.713488,-87.635027);
delete from epa_hourly_o3 where latitude not in (42.139996,41.855243,41.755832,41.639444,41.855243) and longitude not in (-87.799227,-87.75247,-87.54535,-87.493611,-87.75247);
delete from epa_hourly_pm10 where latitude not in (42.139996,41.687165,41.687165,41.80118,41.687165) and longitude not in (-87.799227,-87.539315,-87.539315,-87.832349,-87.539315);
delete from epa_hourly_pm25 where latitude not in (42.139996,41.687165,41.864426,41.687165,41.912739) and longitude not in (-87.799227,-87.539315,-87.748902,-87.539315,-87.722673);
delete from epa_8hour_o3 where latitude not in (42.139996,41.855243,41.755832,41.639444,41.855243) and longitude not in (-87.799227,-87.75247,-87.54535,-87.493611,-87.75247);

longitude  | latitude
------------+-----------
-87.799227 | 42.139996
-87.495044 | 41.594427
-87.863225 | 42.060285
/* A lookup table for joining epa sensor location with the nearest community in SASA database */
create table epa_sensors_community_lookup(
  community character varying(2),
  pollutant character varying(5),
  latitude double precision,
  longitude double precision
);
truncate table epa_sensors_community_lookup;
insert into epa_sensors_community_lookup values ('LV','pm10',41.80118,-87.832349);
insert into epa_sensors_community_lookup values ('NB','pm10', 41.80118,-87.832349);
insert into epa_sensors_community_lookup values ('PC','pm10',41.687165,-87.539315);
insert into epa_sensors_community_lookup values ('SE','pm10',41.687165,-87.539315);
insert into epa_sensors_community_lookup values ('SL','pm10',41.687165,-87.539315);
insert into epa_sensors_community_lookup values ('LV','pm2.5',42.060285,-87.863225);
insert into epa_sensors_community_lookup values ('NB','pm2.5',42.139996,-87.799227);
insert into epa_sensors_community_lookup values ('PC','pm2.5',41.606667,-87.304722);
insert into epa_sensors_community_lookup values ('SE','pm2.5',41.606667,-87.304722);
insert into epa_sensors_community_lookup values ('SL','pm2.5',42.060285,-87.863225);
insert into epa_sensors_community_lookup values ('LV','no2',41.855243,-87.75247);
insert into epa_sensors_community_lookup values ('NB','no2',41.855243,-87.75247);
insert into epa_sensors_community_lookup values ('PC','no2',41.7514,-87.713488);
insert into epa_sensors_community_lookup values ('SE','no2',41.7514,-87.713488);
insert into epa_sensors_community_lookup values ('SL','no2',41.877682,-87.635027);
insert into epa_sensors_community_lookup values ('LV','o3',41.855243,-87.75247);
insert into epa_sensors_community_lookup values ('NB','o3',42.139996,-87.799227);
insert into epa_sensors_community_lookup values ('PC','o3',41.639444,-87.493611);
insert into epa_sensors_community_lookup values ('SE','o3',41.755832,-87.54535);
insert into epa_sensors_community_lookup values ('SL','o3',41.855243,-87.75247);
insert into epa_sensors_community_lookup values ('LV','co',42.139996,-87.799227);
insert into epa_sensors_community_lookup values ('NB','co',42.139996,-87.799227);
insert into epa_sensors_community_lookup values ('PC','co',41.629073,-87.461554);
insert into epa_sensors_community_lookup values ('SE','co',41.629073,-87.461554);
insert into epa_sensors_community_lookup values ('SL','co',41.629073,-87.461554);

/* Adding a column to identify the data completeness for all the devices */
alter table stationarylocations add column data_completeness numeric;
select unit_id,season,community,round(sum(case when flag is null then 1 else 0 end)::numeric/count(*)::numeric*100) as completeness from aeroqualno2 where flag is distinct from 1 group by unit_id,season,community;
select unit_id,season,community,round(sum(case when flag is null then 1 else 0 end)::numeric/count(*)::numeric*100) as completeness from aeroqualo3 where flag is distinct from 1 group by unit_id,season,community;


/* Reset the flag for all tables */
update metone set flag=null;
update aeroqualo3 set flag=null;
update aeroqualno2 set flag=null;
update purpleair set flag=null;
update airterrier set flag=null;

/* Adding the flag column to track the quality checks */
alter table  aeroqualno2 add column flag integer;
alter table  aeroqualo3 add column flag integer;
alter table  airterrier add column flag integer;
alter table  metone add column flag integer;
alter table  purpleair add column flag integer;
alter table  stationarylocations add column flag integer;
alter table  wundergound add column flag integer;

/* Backed up the tables for recovery if necessary */
\COPY aeroqualno2 TO 'aeroqualno2.csv' DELIMITER ',' CSV HEADER;
\COPY aeroqualo3 TO 'aeroqualo3.csv' DELIMITER ',' CSV HEADER;
\COPY airterrier TO 'airterrier.csv' DELIMITER ',' CSV HEADER;
\COPY metone TO 'metone.csv' DELIMITER ',' CSV HEADER;
\COPY purpleair_lv TO 'purpleair_lv.csv' DELIMITER ',' CSV HEADER;
\COPY purpleair_pc TO 'purpleair_pc.csv' DELIMITER ',' CSV HEADER;
\COPY purpleair_nb TO 'purpleair_nb.csv' DELIMITER ',' CSV HEADER;
\COPY purpleair_se TO 'purpleair_se.csv' DELIMITER ',' CSV HEADER;
\COPY purpleair_sl TO 'purpleair_sl.csv' DELIMITER ',' CSV HEADER;
\COPY stationarylocations TO 'stationarylocations.csv' DELIMITER ',' CSV HEADER;
\COPY wundergound TO 'wundergound.csv' DELIMITER ',' CSV HEADER;

/* Creating table that stores the readings that are identified as suspicouos and the visual inspection result */
create table metone_suspect(
  unit_id   character varying(30),
  type      character varying(20),
  device    integer,
  season    character varying(20),
  community character varying(2),
  value     numeric,
  suspect_reason character varying(100),
  count_of_rows     numeric,
  start_time      timestamp with time zone,
  end_time      timestamp with time zone,
  output   character varying(30),
  comments   character varying(300)
);
create table aeroqualno2_suspect(
  unit_id   character varying(30),
  monitorid    integer,
  locationid    integer,
  season    character varying(20),
  community character varying(2),
  value     numeric,
  suspect_reason character varying(100),
  count_of_rows     numeric,
  start_time      timestamp with time zone,
  end_time      timestamp with time zone,
  output   character varying(30),
  comments   character varying(300)
);
create table aeroqualo3_suspect(
  unit_id   character varying(30),
  monitorid    integer,
  locationid    integer,
  season    character varying(20),
  community character varying(2),
  value     numeric,
  suspect_reason character varying(100),
  count_of_rows     numeric,
  start_time      timestamp with time zone,
  end_time      timestamp with time zone,
  output   character varying(30),
  comments   character varying(300)
);
create table purpleair_suspect(
  device_name           character varying(20),
  entry_id    integer,
  season              character varying(20),
  community         character varying(2),
  type character varying(5),
  value     double precision,
  suspect_reason character varying(100),
  count_of_rows     numeric,
  start_time      timestamp with time zone,
  end_time      timestamp with time zone,
  output   character varying(30),
  comments   character varying(300)
);
create table airterrier_suspect(
  session_title       character varying(40),
  username            character varying(30),
  measurement_type    character varying(30),
  sensor_package_name character varying(30),
  unit_name           character varying(30),
  season              character varying(20),
  community           character varying(2),
  sensor_name         character varying(40),
  value     numeric,
  suspect_reason character varying(100),
  count_of_rows     numeric,
  start_time      timestamp with time zone,
  end_time      timestamp with time zone,
  output   character varying(30),
  comments   character varying(300)
);
/* creating additional suspect table for airterrier for parallel processing */
create table airterrier_suspect_sl as select * from airterrier_suspect where 1=0;
create table airterrier_suspect_se as select * from airterrier_suspect where 1=0;
create table airterrier_suspect_lv as select * from airterrier_suspect where 1=0;
create table airterrier_suspect_nb as select * from airterrier_suspect where 1=0;
create table airterrier_suspect_pc as select * from airterrier_suspect where 1=0;

/* Do the range checks.
flag=91 made invalid due to value out of the expected range
flag=51 made suspect due to value range is unusual, need visual inspection on these */
/* 1.	Purple Air maximum range is 1000 μg/m3. We recommend flagging concentrations above 500 μg/m3 as suspect and perform visual inspection. */
update purpleair set flag=91 where pm25_cf_atm_ugm3 >1000 and flag is null; -- found 278
update purpleair set flag=91 where pm1_cf_atm_ugm3 >1000 and flag is null; -- found 0
update purpleair set flag=91 where pm10_cf_atm_ugm3 >1000 and flag is null; -- found 0
update purpleair set flag=50 where pm25_cf_atm_ugm3 >=500 and pm25_cf_atm_ugm3 <= 1000 and flag is null; -- found 150
insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) select device_name,entry_id,season,community,'PM25',pm25_cf_atm_ugm3,1,created_at,created_at,'Value is in suspicion range between 500 and 1000 ugm3' from purpleair where pm25_cf_atm_ugm3 >=500 and pm25_cf_atm_ugm3 <= 1000 and flag=50;
update purpleair set flag=50 where pm1_cf_atm_ugm3 >=500 and pm1_cf_atm_ugm3 <= 1000 and flag is null; -- found 0
update purpleair set flag=50 where pm10_cf_atm_ugm3 >=500 and pm10_cf_atm_ugm3 <= 1000 and flag is null; -- found 99
insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) select device_name,entry_id,season,community,'PM10',pm10_cf_atm_ugm3,1,created_at,created_at,'Value is in suspicion range between 500 and 1000 ugm3' from purpleair where pm10_cf_atm_ugm3 >=500 and pm10_cf_atm_ugm3 <= 1000 and flag=50;
/* 2.	The AirBeam operable ranges is 1-400 μg/m3. Flag concentrations above 300 μg/m3 as suspect and perform visual inspection. */

/* 3.	I cannot find any guidance on the MetOne instrument as they don’t even seem to offer it anymore for sale. I would say that if temperatures are below 0 C, then I would label data as suspect because of our experience with the instrument. */
update metone set flag=51 where (time at time zone 'cdt') in (select date_trunc('hour', (observation_time at time zone 'cdt')) + date_part('minute', (observation_time at time zone 'cdt'))::int / 1 * interval '1 min' AS minutes from wundergound,(select max(time) dend,min(time) dstart from metone) ae where temp_f<32 and (observation_time  at time zone 'cdt')>= dstart and (observation_time at time zone 'cdt')<= dend group by 1) and flag is null; -- found 510
insert into metone_suspect(unit_id,device,type,season,community,value,count_of_rows,start_time,end_time) select unit_id,device,type,season,community,value,1,time,time from metone where flag=51;
psql -p 5432 -h postgresql.cs.ksu.edu -d sasaairqualityproject -U sasaairqualityproject -c "select 'update metone_suspect set suspect_reason=''The temperature is '||temp_f||' on time '||observation_time||''' where date_trunc(''hour'', (start_time at time zone ''cst'')) + date_part(''minute'', (start_time at time zone ''cst''))::int / 1 * interval ''1 min''='''||date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'||''';'  from wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min' in (
select date_trunc('hour', (time at time zone 'cst')) + date_part('minute', (time at time zone 'cst'))::int / 1 * interval '1 min' from metone where flag=51)" > metone_suspect.sql
psql -p 5432 -h postgresql.cs.ksu.edu -d sasaairqualityproject -U sasaairqualityproject -f metone_suspect.sql

/* 4.	For the Aeroqual 500 NOx head, they list acceptable ranges of temperature of 0 to 40 C, RH of 15-90%. We should flag data outside of these ranges as suspect.  It is rated to 1000 ppb, which I assume you did not see. -- found 464 */
update aeroqualno2 set flag=null where flag=51;
update aeroqualno2 set flag=51 where date_trunc('hour', (date at time zone 'cdt')) + date_part('minute', (date at time zone 'cdt'))::int / 1 * interval '1 min' in (select date_trunc('hour', (observation_time at time zone 'cdt')) + date_part('minute', (observation_time at time zone 'cdt'))::int / 1 * interval '1 min' AS minutes from wundergound,(select max(date) dend,min(date) dstart,community from aeroqualno2 group by community) ae where (observation_time  at time zone 'cdt')>= dstart and (observation_time at time zone 'cdt')<= dend and ae.community=wundergound.community group by 1 having avg(temp_f)<32 or avg(temp_f)>104 or avg(relative_humidity)<10 or avg(relative_humidity)>90)  and flag is null; -- 332
-- For the summer
update aeroqualno2 set flag=51 where date_trunc('hour', (date at time zone 'cdt')) + date_part('minute', (date at time zone 'cdt'))::int / 15 * interval '15 min' in (select date_trunc('hour', (observation_time at time zone 'cdt')) + date_part('minute', (observation_time at time zone 'cdt'))::int / 15 * interval '15 min' AS minutes from wundergound,(select max(date) dend,min(date) dstart,community from aeroqualno2 where date<=date('2017-12-08') group by community) ae where (observation_time  at time zone 'cdt')>= dstart and (observation_time at time zone 'cdt')<= dend and ae.community=wundergound.community group by 1 having avg(temp_f)<32 or avg(temp_f)>104 or avg(relative_humidity)<10 or avg(relative_humidity)>90) and flag is distinct from 1; -- 4180
update aeroqualno2 set flag=51 where no2ppm<0 or no2ppm*1000>1000  and flag is null; -- 0 found

insert into aeroqualno2_suspect(unit_id,monitorid,locationid,season,community,value,count_of_rows,start_time,end_time,suspect_reason) select unit_id,monitorid,locationid,season,community,no2ppm,1,date,date,'Temperature or RH value out of acceptable range'  from aeroqualno2 where flag=51;

psql -p 5432 -h postgresql.cs.ksu.edu -d sasaairqualityproject -U sasaairqualityproject -c "select 'update aeroqualno2_suspect set suspect_reason=''The temperature is '||temp_f||'  and RH value is '||relative_humidity||' on time '||observation_time||''' where date_trunc(''hour'', (start_time at time zone ''cst'')) + date_part(''minute'', (start_time at time zone ''cst''))::int / 1 * interval ''1 min''='''||date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'||''';'  from wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min' in (
select date_trunc('hour', (date at time zone 'cst')) + date_part('minute', (date at time zone 'cst'))::int / 1 * interval '1 min' from aeroqualno2 where flag=51)" > aeroqualno2_suspect.sql
-- for summer data
psql -p 5432 -h postgresql.cs.ksu.edu -d sasaairqualityproject -U sasaairqualityproject -c "select 'update aeroqualno2_suspect set suspect_reason=''The temperature is '||temp_f||'  and RH value is '||relative_humidity||' on time '||observation_time||''' where date_trunc(''hour'', (start_time at time zone ''cst'')) + date_part(''minute'', (start_time at time zone ''cst''))::int / 15 * interval ''15 min''='''||date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 15 * interval '15 min'||''';'  from wundergound where date(observation_time)<date('2017-12-08') and date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 15 * interval '15 min' in (
select date_trunc('hour', (date at time zone 'cst')) + date_part('minute', (date at time zone 'cst'))::int / 15 * interval '15 min' from aeroqualno2 where flag=51)" > aeroqualno2_suspect.sql
psql -p 5432 -h postgresql.cs.ksu.edu -d sasaairqualityproject -U sasaairqualityproject -f aeroqualno2_suspect.sql

/* 5.	For the ozone head, I assume the 0-150 ppb version, they list 10-90% RH and 0-40 C operating temperature. */
update aeroqualo3 set flag=51 where date_trunc('hour', (date at time zone 'cdt')) + date_part('minute', (date at time zone 'cdt'))::int / 1 * interval '1 min' in (select date_trunc('hour', (observation_time at time zone 'cdt')) + date_part('minute', (observation_time at time zone 'cdt'))::int / 1 * interval '1 min' AS minutes from wundergound,(select max(date) dend,min(date) dstart,community from aeroqualo3 group by community) ae where temp_f<32 or temp_f>104 or relative_humidity<10 or relative_humidity>90 and (observation_time  at time zone 'cdt')>= dstart and (observation_time at time zone 'cdt')<= dend and ae.community=wundergound.community group by 1) and flag is null; -- 0 found
-- For the summer
update aeroqualo3 set flag=51 where date_trunc('hour', (date at time zone 'cdt')) + date_part('minute', (date at time zone 'cdt'))::int / 15 * interval '15 min' in (select date_trunc('hour', (observation_time at time zone 'cdt')) + date_part('minute', (observation_time at time zone 'cdt'))::int / 15 * interval '15 min' AS minutes from wundergound,(select max(date) dend,min(date) dstart,community from aeroqualo3 where date<=date('2017-12-08') group by community) ae where temp_f<32 or temp_f>104 or relative_humidity<10 or relative_humidity>90 and (observation_time  at time zone 'cdt')>= dstart and (observation_time at time zone 'cdt')<= dend and ae.community=wundergound.community group by 1) and flag is null; -- 0 found
update aeroqualo3 set flag=51 where o3ppm<0 or o3ppm*1000>150 and flag is null; -- 0 found
select 'update aeroqualo3 set flag=51 where (date_trunc(''hour'', date) + date_part(''minute'', date)::int / 1 * interval ''1 min'' at time zone ''cst'')='''||minutes||''' and community='''||community||''';' from (select (date_trunc('hour', observation_time) + date_part('minute', observation_time)::int / 1 * interval '1 min' at time zone 'cst') AS minutes,community from wundergound where temp_f between 32 and 104 and relative_humidity between 10 and 90 group by 1,community order by 2,1) c;

/* To identify the stuck value for metone that have 4 consecutive values same */
update metone set flag=null where flag=52;
select * from metone order by type,unit_id,device,season,community,time;
CREATE OR REPLACE FUNCTION mark_stuck_metone() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from metone order by type,unit_id,device,season,community,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.value=prev_rec.value and rec.type=prev_rec.type and rec.unit_id=prev_rec.unit_id and rec.device=prev_rec.device and rec.season=prev_rec.season and rec.community=prev_rec.community then
  			match_count:=match_count+1;
  		elsif match_count>2 then
  			update metone set flag=52 where value=prev_rec.value and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into metone_suspect(unit_id,device,type,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.device,prev_rec.type,prev_rec.season,prev_rec.community,prev_rec.value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		else
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_metone();


-- For aeroqualno2
update aeroqualno2 set flag=null where flag=52;
select * from aeroqualno2 where flag is not null order by unit_id,monitorid,locationid,season,community,date;
CREATE OR REPLACE FUNCTION mark_stuck_aeroqualno2() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from aeroqualno2 order by unit_id,monitorid,locationid,season,community,date loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.no2ppm=prev_rec.no2ppm and rec.monitorid=prev_rec.monitorid and rec.unit_id=prev_rec.unit_id and rec.locationid=prev_rec.locationid and rec.season=prev_rec.season and rec.community=prev_rec.community then
  			match_count:=match_count+1;
  		elsif match_count>2 then
  			update aeroqualno2 set flag=52 where no2ppm=prev_rec.no2ppm and monitorid=prev_rec.monitorid and unit_id=prev_rec.unit_id and locationid=prev_rec.locationid and season=prev_rec.season and community=prev_rec.community and date>=first_rec.date and date<=prev_rec.date and flag is null;
        insert into aeroqualno2_suspect(unit_id,monitorid,locationid,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.monitorid,prev_rec.locationid,prev_rec.season,prev_rec.community,prev_rec.no2ppm,match_count+1,first_rec.date,prev_rec.date,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		else
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_aeroqualno2();


-- For aeroqualo3
update aeroqualo3 set flag=null where flag=52;
select * from aeroqualo3 where flag is not null order by unit_id,monitorid,locationid,season,community,date;
CREATE OR REPLACE FUNCTION mark_stuck_aeroqualo3() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from aeroqualo3 order by unit_id,monitorid,locationid,season,community,date loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.o3ppm=prev_rec.o3ppm and rec.monitorid=prev_rec.monitorid and rec.unit_id=prev_rec.unit_id and rec.locationid=prev_rec.locationid and rec.season=prev_rec.season and rec.community=prev_rec.community then
  			match_count:=match_count+1;
  		elsif match_count>2 then
  			update aeroqualo3 set flag=52 where o3ppm=prev_rec.o3ppm and monitorid=prev_rec.monitorid and unit_id=prev_rec.unit_id and locationid=prev_rec.locationid and season=prev_rec.season and community=prev_rec.community and date>=first_rec.date and date<=prev_rec.date and flag is null;
        insert into aeroqualo3_suspect(unit_id,monitorid,locationid,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.monitorid,prev_rec.locationid,prev_rec.season,prev_rec.community,prev_rec.o3ppm,match_count+1,first_rec.date,prev_rec.date,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		else
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_aeroqualo3();


-- For airterrier
update airterrier set flag=null where flag=52;
select * from airterrier where upper(SUBSTRING(session_title, 1, 2))='LV' order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time;
CREATE OR REPLACE FUNCTION mark_stuck_airterrier_lv() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from airterrier_lv where flag is distinct from 1 and flag is distinct from 51 order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.measured_value=prev_rec.measured_value and rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.sensor_package_name=prev_rec.sensor_package_name and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.sensor_name=prev_rec.sensor_name then
        update airterrier_lv set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
  			match_count:=match_count+1;
  		else
  			update airterrier_lv set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into airterrier_suspect_lv(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stuck_airterrier_nb() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from airterrier_nb where flag is distinct from 1 and flag is distinct from 51 order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.measured_value=prev_rec.measured_value and rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.sensor_package_name=prev_rec.sensor_package_name and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.sensor_name=prev_rec.sensor_name then
        update airterrier_nb set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
  			match_count:=match_count+1;
  		else
  			update airterrier_nb set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into airterrier_suspect_nb(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stuck_airterrier_pc() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from airterrier_pc where flag is distinct from 1 and flag is distinct from 51 order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.measured_value=prev_rec.measured_value and rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.sensor_package_name=prev_rec.sensor_package_name and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.sensor_name=prev_rec.sensor_name then
        update airterrier_pc set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
  			match_count:=match_count+1;
  		else
  			update airterrier_pc set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into airterrier_suspect_pc(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stuck_airterrier_se() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from airterrier_se where flag is distinct from 1 and flag is distinct from 51 order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.measured_value=prev_rec.measured_value and rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.sensor_package_name=prev_rec.sensor_package_name and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.sensor_name=prev_rec.sensor_name then
        update airterrier_se set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
  			match_count:=match_count+1;
  		else
  			update airterrier_se set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into airterrier_suspect_se(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stuck_airterrier_nb() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  	for rec in select * from airterrier_nb where flag is distinct from 1 and flag is distinct from 51 order by session_title,username,measurement_type,sensor_package_name,unit_name,season,sensor_name,time loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
  		elsif rec.measured_value=prev_rec.measured_value and rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.sensor_package_name=prev_rec.sensor_package_name and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.sensor_name=prev_rec.sensor_name then
        update airterrier_nb set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
  			match_count:=match_count+1;
  		else
  			update airterrier_nb set flag=52 where measured_value=prev_rec.measured_value and session_title=prev_rec.session_title and username=prev_rec.username and sensor_package_name=prev_rec.sensor_package_name and unit_name=prev_rec.unit_name and season=prev_rec.season and sensor_name=prev_rec.sensor_name and time>=first_rec.time and time<=prev_rec.time and flag is null;
        insert into airterrier_suspect_nb(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Stuck values');
  			match_count:=0;
  			first_rec:=rec;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_airterrier_pc();
select mark_stuck_airterrier_se();
select mark_stuck_airterrier_sl();
select mark_stuck_airterrier_nb();
select mark_stuck_airterrier_lv();

-- For purpleair
update purpleair_lv set flag=null where flag=52;
select * from purpleair order by community,season,device_name,entry_id,created_at;
CREATE OR REPLACE FUNCTION mark_stuck_purpleair_pm1(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  for rec in select * from purpleair where community=v_community order by community,season,device_name,entry_id,created_at loop
  if match_count=-1 then
  match_count:=0;
  first_rec:=rec;
  elsif rec.community=prev_rec.community and rec.season=prev_rec.season and rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id then
  if rec.pm1_cf_atm_ugm3=prev_rec.pm1_cf_atm_ugm3 then
  match_count:=match_count+1;
  end if;
  elsif match_count>2 then
  --update purpleair set flag=52 where pm1_cf_atm_ugm3=prev_rec.pm1_cf_atm_ugm3 and community=prev_rec.community and season=prev_rec.season and device_name=prev_rec.device_name and entry_id=prev_rec.entry_id and created_at>=first_rec.created_at and created_at<=prev_rec.created_at and community=v_community and flag is null;
  insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM1',prev_rec.pm1_cf_atm_ugm3,match_count+1,first_rec.created_at,prev_rec.created_at,'Stuck values');
  match_count:=0;
  first_rec:=rec;
  else
  match_count:=0;
  first_rec:=rec;
  end if;
  prev_rec:=rec;
  end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_purpleair_pm1('SL');
select mark_stuck_purpleair_pm1('SE');
select mark_stuck_purpleair_pm1('NB');
select mark_stuck_purpleair_pm1('PC');
select mark_stuck_purpleair_pm1('LV');

CREATE OR REPLACE FUNCTION mark_stuck_purpleair_pm25(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  for rec in select * from purpleair where community=v_community order by community,season,device_name,entry_id,created_at loop
  if match_count=-1 then
  match_count:=0;
  first_rec:=rec;
  elsif rec.community=prev_rec.community and rec.season=prev_rec.season and rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id then
  if rec.pm25_cf_atm_ugm3=prev_rec.pm25_cf_atm_ugm3 then
  match_count:=match_count+1;
  end if;
  elsif match_count>2 then
  /* update purpleair set flag=52 where pm25_cf_atm_ugm3=prev_rec.pm25_cf_atm_ugm3 and community=prev_rec.community and season=prev_rec.season and device_name=prev_rec.device_name and entry_id=prev_rec.entry_id and created_at>=first_rec.created_at and created_at<=prev_rec.created_at and community=v_community and flag is null; */
  insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM2.5',prev_rec.pm25_cf_atm_ugm3,match_count+1,first_rec.created_at,prev_rec.created_at,'Stuck values');
  match_count:=0;
  first_rec:=rec;
  else
  match_count:=0;
  first_rec:=rec;
  end if;
  prev_rec:=rec;
  end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_purpleair_pm25('SE');
select mark_stuck_purpleair_pm25('NB');
select mark_stuck_purpleair_pm25('PC');
select mark_stuck_purpleair_pm25('SL');
select mark_stuck_purpleair_pm25('LV');


CREATE OR REPLACE FUNCTION mark_stuck_purpleair_pm10(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  begin
  for rec in select * from purpleair where community=v_community order by community,season,device_name,entry_id,created_at loop
  if match_count=-1 then
  match_count:=0;
  first_rec:=rec;
  elsif rec.community=prev_rec.community and rec.season=prev_rec.season and rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id then
  if rec.pm10_cf_atm_ugm3=prev_rec.pm10_cf_atm_ugm3 then
  match_count:=match_count+1;
  end if;
  elsif match_count>2 then
  --update purpleair set flag=52 where pm10_cf_atm_ugm3=prev_rec.pm10_cf_atm_ugm3 and community=prev_rec.community and season=prev_rec.season and device_name=prev_rec.device_name and entry_id=prev_rec.entry_id and created_at>=first_rec.created_at and created_at<=prev_rec.created_at and community=v_community and flag is null;
  insert into purpeair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM10',prev_rec.pm10_cf_atm_ugm3,match_count+1,first_rec.created_at,prev_rec.created_at,'Stuck values');
  match_count:=0;
  first_rec:=rec;
  else
  match_count:=0;
  first_rec:=rec;
  end if;
  prev_rec:=rec;
  end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stuck_purpleair_pm10('SL');
select mark_stuck_purpleair_pm10('SE');
select mark_stuck_purpleair_pm10('NB');
select mark_stuck_purpleair_pm10('PC');
select mark_stuck_purpleair_pm10('LV');


/* ii.	Outliers are defined as values greater than greater than 3 standard deviations from the mean. These data should be flagged as suspect and visually inspected.  */
/* Identifying value over 3 times more standard deviation 53 flag is used to indicate this */
update aeroqualo3 set flag=53 from (select unit_id,season,community,locationid,monitorid,3*stddev(o3ppm) std_value from aeroqualo3 where flag is null group by unit_id,season,community,locationid,monitorid) stdev where aeroqualo3.unit_id=stdev.unit_id and aeroqualo3.season=stdev.season and aeroqualo3.community=stdev.community and aeroqualo3.monitorid=stdev.monitorid and aeroqualo3.locationid=stdev.locationid and o3ppm>std_value and flag is null; --21966
update aeroqualno2 set flag=53 from (select unit_id,season,community,locationid,monitorid,3*stddev(no2ppm) std_value from aeroqualno2 where flag is null group by unit_id,season,community,locationid,monitorid) stdev where aeroqualno2.unit_id=stdev.unit_id and aeroqualno2.season=stdev.season and aeroqualno2.community=stdev.community and aeroqualno2.monitorid=stdev.monitorid and aeroqualno2.locationid=stdev.locationid and no2ppm>std_value and flag is null; -- 32977
update metone set flag=53 from (select unit_id,season,community,device,type,3*stddev(value) std_value from metone where flag is null group by unit_id,season,community,type,device) stdev where metone.unit_id=stdev.unit_id and metone.season=stdev.season and metone.community=stdev.community and metone.type=stdev.type and metone.device=stdev.device and value>std_value and flag is null; -- 2294
update purpleair set flag=53 from (select device_name,entry_id,season,community,3*stddev(pm25_cf_atm_ugm3) std_value from purpleair where flag is distinct from 1 group by device_name,entry_id,season,community) stdev where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and pm25_cf_atm_ugm3>std_value and flag is null; -- 32977+5663
update purpleair set flag=53 from (select device_name,entry_id,season,community,3*stddev(pm1_cf_atm_ugm3) std_value from purpleair where flag is distinct from 1 group by device_name,entry_id,season,community) stdev where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and pm1_cf_atm_ugm3>std_value and flag is null; -- 98+437
update purpleair set flag=53 from (select device_name,entry_id,season,community,3*stddev(pm10_cf_atm_ugm3) std_value from purpleair where flag is distinct from 1 group by device_name,entry_id,season,community) stdev where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and pm10_cf_atm_ugm3>std_value and flag is null; -- 10+194
update airterrier_nb set flag=53 from (select session_title,username,unit_name,measurement_type,season,community,3*stddev(measured_value) std_value from airterrier_nb where flag is null group by session_title,username,unit_name,measurement_type,season,community) stdev where airterrier_nb.session_title=stdev.session_title and airterrier_nb.season=stdev.season and airterrier_nb.community=stdev.community and airterrier_nb.username=stdev.username and airterrier_nb.measurement_type=stdev.measurement_type and airterrier_nb.unit_name=stdev.unit_name and measured_value>std_value and flag is null; --
update airterrier set flag=53 from (select session_title,username,unit_name,measurement_type,season,community,3*stddev(measured_value) std_value from airterrier where flag is null group by session_title,username,unit_name,measurement_type,season,community) stdev where airterrier.session_title=stdev.session_title and airterrier.season=stdev.season and airterrier.community=stdev.community and airterrier.username=stdev.username and airterrier.measurement_type=stdev.measurement_type and airterrier.unit_name=stdev.unit_name and measured_value>std_value and airterrier.measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null; --

/* Populate into suspect table for standard deviation suspect */
delete from metone_suspect where suspect_reason like 'Value%' or suspect_reason like '1:Value%';
CREATE OR REPLACE FUNCTION mark_stddev_metone() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select type,device,unit_id,season,community,time,value,(select round(stddev(value),2) from metone where type=m1.type and device=m1.device and unit_id=m1.unit_id and season=m1.season and community=m1.community and flag is distinct from 1) stdev from metone m1 where flag=53 order by type,device,unit_id,season,community,time loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.value;
    elsif rec.type=prev_rec.type and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.unit_id=prev_rec.unit_id and rec.device=prev_rec.device and rec.time-prev_rec.time < time '00:16' then
        match_count:=match_count+1;
        v_value:=v_value+rec.value;
    else
    if v_value=0 THEN
    v_value=0;
    else
    v_value:=(v_value/(match_count+1));
    end if;
    -- update metone set flag=53 where value=prev_rec.value and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and time>=first_rec.time and time<=prev_rec.time and flag is null;
    insert into metone_suspect(unit_id,device,type,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.device,prev_rec.type,prev_rec.season,prev_rec.community,v_value,match_count+1,first_rec.time,prev_rec.time,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.value;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stddev_metone();
\copy (select * from metone_suspect where suspect_reason like 'Value%') to 'metone_suspect_std.csv' (format csv,header);


delete from aeroqualno2_suspect where suspect_reason like 'Value%' or suspect_reason like '1:Value%';
CREATE OR REPLACE FUNCTION mark_stddev_aeroqualno2() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select unit_id,season,community,locationid,monitorid,date,no2ppm,(select stddev(no2ppm) from aeroqualno2 where aeroqualno2.unit_id=stdev.unit_id and aeroqualno2.season=stdev.season and aeroqualno2.community=stdev.community and aeroqualno2.monitorid=stdev.monitorid and aeroqualno2.locationid=stdev.locationid and flag is distinct from 1 and error is distinct from 1) stdev from aeroqualno2 stdev where flag=53 order by unit_id,season,community,locationid,monitorid,date loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.no2ppm;
    elsif rec.monitorid=prev_rec.monitorid and rec.unit_id=prev_rec.unit_id and rec.locationid=prev_rec.locationid and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.date-prev_rec.date < time '00:16' then
        match_count:=match_count+1;
        v_value:=v_value+rec.no2ppm;
    else
      if v_value=0 THEN
          v_value=0;
        else
          v_value:=(v_value/(match_count+1));
      end if;
    -- update aeroqualno2 set flag=53 where no2ppm=prev_rec.no2ppm and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and date>=first_rec.date and date<=prev_rec.date and flag is null;
    insert into aeroqualno2_suspect(unit_id,monitorid,locationid,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.monitorid,prev_rec.locationid,prev_rec.season,prev_rec.community,v_value,match_count+1,first_rec.date,prev_rec.date,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.no2ppm;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stddev_aeroqualno2();
\copy (select * from aeroqualno2_suspect where suspect_reason like 'Value%') to 'aeroqualno2_suspect_std.csv' (format csv,header);

delete from aeroqualo3_suspect where suspect_reason like 'Value%' or suspect_reason like '1:Value%';
CREATE OR REPLACE FUNCTION mark_stddev_aeroqualo3() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select unit_id,season,community,locationid,monitorid,date,o3ppm,(select stddev(o3ppm) from aeroqualo3 where aeroqualo3.unit_id=stdev.unit_id and aeroqualo3.season=stdev.season and aeroqualo3.community=stdev.community and aeroqualo3.monitorid=stdev.monitorid and aeroqualo3.locationid=stdev.locationid and flag is distinct from 1 ) stdev from aeroqualo3 stdev where flag=53 order by unit_id,season,community,locationid,monitorid,date loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.o3ppm;
    elsif rec.monitorid=prev_rec.monitorid and rec.unit_id=prev_rec.unit_id and rec.locationid=prev_rec.locationid and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.date-prev_rec.date < time '00:16' then
        match_count:=match_count+1;
        v_value:=v_value+rec.o3ppm;
    else
    if v_value=0 THEN
    v_value=0;
    else
    v_value:=(v_value/(match_count+1));
    end if;
    -- update aeroqualo3 set flag=53 where o3ppm=prev_rec.o3ppm and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and date>=first_rec.date and date<=prev_rec.date and flag is null;
    insert into aeroqualo3_suspect(unit_id,monitorid,locationid,season,community,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.unit_id,prev_rec.monitorid,prev_rec.locationid,prev_rec.season,prev_rec.community,(v_value/match_count+1),match_count+1,first_rec.date,prev_rec.date,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.o3ppm;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stddev_aeroqualo3();
\copy (select * from aeroqualo3_suspect where suspect_reason like 'Value%') to 'aeroqualo3_suspect_std.csv' (format csv,header);


CREATE OR REPLACE FUNCTION mark_stddev_purpleair_pm25(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select distinct device_name,entry_id,season,community,created_at,pm25_cf_atm_ugm3,(select stddev(pm25_cf_atm_ugm3) from purpleair where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and flag is distinct from 1) stdev from purpleair stdev where community=v_community and flag=53 loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm25_cf_atm_ugm3;
    elsif rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.created_at-prev_rec.created_at < time '00:02' then
        match_count:=match_count+1;
        v_value:=v_value+rec.pm25_cf_atm_ugm3;
    else
    -- update purpleair_pm25 set flag=53 where pm25_cf_atm_ugm3=prev_rec.pm25_cf_atm_ugm3 and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and date>=first_rec.created_at and date<=prev_rec.created_at and flag is null;
    if v_value=0 THEN
    v_value=0;
    else
    v_value:=(v_value/(match_count+1));
    end if;
    insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM25',v_value,match_count+1,first_rec.created_at,prev_rec.created_at,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm25_cf_atm_ugm3;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stddev_purpleair_pm1(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select distinct device_name,entry_id,season,community,created_at,pm1_cf_atm_ugm3,(select stddev(pm1_cf_atm_ugm3) from purpleair where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and flag is distinct from 1) stdev from purpleair stdev where community=v_community and flag=53 loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm1_cf_atm_ugm3;
    elsif rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.created_at-prev_rec.created_at < time '00:02' then
        match_count:=match_count+1;
        v_value:=v_value+rec.pm1_cf_atm_ugm3;
    else
    -- update purpleair_pm25 set flag=53 where pm1_cf_atm_ugm3=prev_rec.pm1_cf_atm_ugm3 and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and date>=first_rec.created_at and date<=prev_rec.created_at and flag is null;
    if v_value=0 THEN
    v_value=0;
    else
    v_value:=(v_value/(match_count+1));
    end if;
    insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM1',v_value,match_count+1,first_rec.created_at,prev_rec.created_at,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm1_cf_atm_ugm3;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
CREATE OR REPLACE FUNCTION mark_stddev_purpleair_pm10(v_community varchar) RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select distinct device_name,entry_id,season,community,created_at,pm10_cf_atm_ugm3,(select stddev(pm10_cf_atm_ugm3) from purpleair where purpleair.device_name=stdev.device_name and purpleair.season=stdev.season and purpleair.community=stdev.community and purpleair.entry_id=stdev.entry_id and flag is distinct from 1) stdev from purpleair stdev where community=v_community and flag=53 loop
    if match_count=-1 then
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm10_cf_atm_ugm3;
    elsif rec.device_name=prev_rec.device_name and rec.entry_id=prev_rec.entry_id and rec.season=prev_rec.season and rec.community=prev_rec.community and rec.created_at-prev_rec.created_at < time '00:02' then
        match_count:=match_count+1;
        v_value:=v_value+rec.pm10_cf_atm_ugm3;
    else
    -- update purpleair_pm25 set flag=53 where pm10_cf_atm_ugm3=prev_rec.pm10_cf_atm_ugm3 and type=prev_rec.type and unit_id=prev_rec.unit_id and device=prev_rec.device and season=prev_rec.season and community=prev_rec.community and date>=first_rec.created_at and date<=prev_rec.created_at and flag is null;
    if v_value=0 THEN
    v_value=0;
    else
    v_value:=(v_value/(match_count+1));
    end if;
    insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.device_name,prev_rec.entry_id,prev_rec.season,prev_rec.community,'PM10',v_value,match_count+1,first_rec.created_at,prev_rec.created_at,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
      match_count:=0;
      first_rec:=rec;
      v_value:=rec.pm10_cf_atm_ugm3;
    end if;
    prev_rec:=rec;
    end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stddev_purpleair_pm10('LV');
select mark_stddev_purpleair_pm10('NB');
select mark_stddev_purpleair_pm10('PC');
select mark_stddev_purpleair_pm10('SE');
select mark_stddev_purpleair_pm10('SL');
select mark_stddev_purpleair_pm25('LV');
select mark_stddev_purpleair_pm25('NB');
select mark_stddev_purpleair_pm25('PC');
select mark_stddev_purpleair_pm25('SE');
select mark_stddev_purpleair_pm25('SL');
select mark_stddev_purpleair_pm1('LV');
select mark_stddev_purpleair_pm1('NB');
select mark_stddev_purpleair_pm1('PC');
select mark_stddev_purpleair_pm1('SE');
select mark_stddev_purpleair_pm1('SL');

CREATE OR REPLACE FUNCTION mark_stddev_airterrier() RETURNS void AS $$
  DECLARE
  rec record;
  match_count int:=-1;
  prev_rec record;
  first_rec record;
  v_value double precision;
  begin
  	for rec in select session_title,username,unit_name,measurement_type,season,community,(select stddev(measured_value) std_value from airterrier as stdev where airterrier.session_title=stdev.session_title and airterrier.season=stdev.season and airterrier.community=stdev.community and airterrier.username=stdev.username and airterrier.measurement_type=stdev.measurement_type and airterrier.unit_name=stdev.unit_name and flag is null) stdev from airterrier where flag=53 loop
  		if match_count=-1 then
  			match_count:=0;
  			first_rec:=rec;
        v_value:=rec.measured_value;
  		elsif rec.session_title=prev_rec.session_title and rec.username=prev_rec.username and rec.community=prev_rec.community and rec.unit_name=prev_rec.unit_name and rec.season=prev_rec.season and rec.measurement_type=prev_rec.measurement_type and rec.time-prev_rec.time < time '00:02' then
  			match_count:=match_count+1;
        v_value:=v_value+rec.measured_value;
  		else
        if v_value=0 THEN
        v_value=0;
        else
        v_value:=(v_value/(match_count+1));
        end if;
        insert into airterrier_suspect(session_title,username,measurement_type,sensor_package_name,unit_name,season,community,sensor_name,value,count_of_rows,start_time,end_time,suspect_reason) values(prev_rec.session_title,prev_rec.username,prev_rec.measurement_type,prev_rec.sensor_package_name,prev_rec.unit_name,prev_rec.season,prev_rec.community,prev_rec.sensor_name,prev_rec.measured_value,match_count+1,first_rec.time,prev_rec.time,'Value is greater than 3rd standard deviation:'||prev_rec.stdev);
  			match_count:=0;
  			first_rec:=rec;
        v_value:=rec.measured_value;
  		end if;
  		prev_rec:=rec;
  	end loop;
  END;
$$ LANGUAGE 'plpgsql' STRICT;
select mark_stddev_airterrier();

/* e.	Check for instrument specific issues (e.g., Purple Air internal consistency between two sensors, temp/RH ranges, etc.) */
/* ii.	For all particle measurements, flag values when RH> 95% as suspect. */
/* PM are above 80% (8156) and how many are above 95% (3100) and between 80% and 95% (8156) */
select count(*) from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>80 and purpleair.flag is null;
select count(*) from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>80 and relative_humidity<=95 and purpleair.flag is null;
select count(*) from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>95 and purpleair.flag is null;
/* Total purpleair readings that are not invalid
1984426
Total purpleair reading with RH above 95% is 3100 (0.15%)
Total purpleair reading with RH above 80% is 8156 (0.41%) */
update purpleair set flag=51 from wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>80 and purpleair.flag is null and purpleair.pm10_cf_atm_ugm3>100;
insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) select  purpleair.device_name,purpleair.entry_id,purpleair.season,purpleair.community,'PM25',purpleair.pm25_cf_atm_ugm3,1,purpleair.created_at,purpleair.created_at,'RH percentage is greater than 80' from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>80 and purpleair.pm25_cf_atm_ugm3>100 order by 1,3,4,7; -- 22
insert into purpleair_suspect(device_name,entry_id,season,community,type,value,count_of_rows,start_time,end_time,suspect_reason) select  purpleair.device_name,purpleair.entry_id,purpleair.season,purpleair.community,'PM10',purpleair.pm25_cf_atm_ugm3,1,purpleair.created_at,purpleair.created_at,'RH percentage is greater than 80' from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and relative_humidity>80 and purpleair.flag =54 and purpleair.pm10_cf_atm_ugm3>100 order by 1,3,4,7; -- 21
\copy (select * from purpleair_suspect where suspect_reason like 'RH%') to 'purpleair_suspect_rh.csv' (format csv,header)

/* iii.	With the same instrument, PM10 should be ≥ PM2.5; if not, both values are likely invalid. Allow 5 to 10% tolerance (will depend on the data set). */
select device_name,community,round((pm10_cf_atm_ugm3-pm25_cf_atm_ugm3)/pm25_cf_atm_ugm3*100),count(*) from purpleair where pm25_cf_atm_ugm3>0 and pm10_cf_atm_ugm3>0 and flag is null group by device_name,community,3 having round((pm10_cf_atm_ugm3-pm25_cf_atm_ugm3)/pm25_cf_atm_ugm3*100)>-10 order by 1,2,3;
update purpleair set flag=11 where round((pm10_cf_atm_ugm3-pm25_cf_atm_ugm3)/pm25_cf_atm_ugm3*100)<-10 and flag is distinct from 1 and pm25_cf_atm_ugm3>0; -- 4830

/* iv.	For Purple Air, flag PM concentrations when the confidence score between channels A and B is less than 80% as suspect. If this is persistent, then one of the channels may be failing. Visual review will be needed to assess which channel is experiencing problems. */
select corr(x1,x2),date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '60 min' from (select t1.pm25_cf_atm_ugm3 x1,t2.pm25_cf_atm_ugm3 x2,t1.created_at from (select pm25_cf_atm_ugm3,created_at from purpleair_sl where device_name='SASA_PA10_SL_S') t1,(select pm25_cf_atm_ugm3,created_at+((select min(created_at) from purpleair_sl where device_name='SASA_PA10_SL_S')-(select min(created_at) from purpleair_sl where device_name='SASA_PA10_SL_SB')) created_at from purpleair_sl where device_name='SASA_PA10_SL_SB') t2 where t1.created_at=t2.created_at) t3 group by 2 order by 2;

/* v.	If the sensors have specifications with optimal temperature ranges, flag concentrations when temperatures are outside those ranges as suspect. */
/* 1.	For the Purple Air, the denoted temperature range is -40 to +85 C (which is likely not what happens in practice). */
select count(*) from purpleair,wundergound where date_trunc('hour', (observation_time at time zone 'cst')) + date_part('minute', (observation_time at time zone 'cst'))::int / 1 * interval '1 min'=date_trunc('hour', (created_at at time zone 'cst')) + date_part('minute', (created_at at time zone 'cst'))::int / 1 * interval '1 min' and purpleair.community=wundergound.community and temp_f<-40 or temp_f>185 and purpleair.flag is null; -- found none
/* 3.	For the AirBeam, flag data when the temperature is outside the range of 32º to 122ºF */
update airterrier_lv set flag=51 where measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null and time in (select time from airterrier where measurement_type='Temperature' and (measured_value<32 or measured_value>122) and community='LV' and flag is null group by time); -- 917
update airterrier_nb set flag=51 where measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null and time in (select time from airterrier where measurement_type='Temperature' and (measured_value<32 or measured_value>122) and community='NB' and flag is null group by time); --
update airterrier_se set flag=51 where measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null and time in (select time from airterrier where measurement_type='Temperature' and (measured_value<32 or measured_value>122) and community='SE' and flag is null group by time); -- 0
update airterrier_sl set flag=51 where measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null and time in (select time from airterrier where measurement_type='Temperature' and (measured_value<32 or measured_value>122) and community='SL' and flag is null group by time); --
update airterrier_pc set flag=51 where measurement_type in ('CO concentration','CO2 concentration','NO concentration','Particulate Matter') and flag is null and time in (select time from airterrier where measurement_type='Temperature' and (measured_value<32 or measured_value>122) and community='PC' and flag is null group by time); --

/* 4.	Data Adjustment –normalize the mobile monitoring data
a.	For each mobile deployment, normalize data such that the average value of each deployment of each sensor is 1. This will allow us to find locations with higher-than-average pollutant concentrations. To do this, first find the average value of all the measurements collected during the mobile deployment (e.g., all mobile data collected by AirBeam A on Day 1) and divide each measurement obtained on that day by that device, by the average. Repeat this for each mobile deployment (e.g., all mobile data collected by AirBeam B on Day 2). */
alter table airterrier_lv add column normalized_data numeric;
update airterrier_lv set normalized_data=measured_value/average_value;
alter table airterrier_pc add column normalized_data numeric;
update airterrier_pc set normalized_data=(case when average_value=0 then 0 else measured_value/average_value end);
alter table airterrier_se add column normalized_data numeric;
update airterrier_se set normalized_data=(case when average_value=0 then 0 else measured_value/average_value end);
alter table airterrier_sl add column normalized_data numeric;
update airterrier_sl set normalized_data=(case when average_value=0 then 0 else measured_value/average_value end);
alter table airterrier_nb add column normalized_data numeric;
update airterrier_nb set normalized_data=(case when average_value=0 then 0 else measured_value/average_value end);

/* b.	Depending on the variability in concentrations normalization of the (normalized) mobile data to a central monitoring location may also be needed.  */


/* update all the tables with the flag from suspect inspection */
update metone_suspect set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update metone_suspect set flag=51 where suspect_reason like 'The temperature is %';
update metone_suspect set flag=52 where suspect_reason like 'Stuck values';
alter table metone_suspect_verified add column flag integer;
update metone_suspect_verified set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update metone_suspect_verified set flag=51 where suspect_reason like 'The temperature is %';
update metone_suspect_verified set flag=52 where suspect_reason like 'Stuck values';
update metone as m set flag=msv.flag from metone_suspect_verified as msv where m.unit_id=msv.unit_id and m.device=msv.device and m.season=msv.season and m.community=msv.community  and (m.time at time zone 'cst')>=(msv.start_time at time zone 'cst') and (m.time at time zone 'cst')<=(msv.end_time at time zone 'cst') and msv.output='Invalid' and m.flag is null;
update metone set flag=52 where unit_id='SASA_MO1' and type='pm10' and device='12396' and value=4 and date(time)=date('2017-09-01');
update  metone set flag=52 where unit_id='SASA_MO3' and type='pm10' and device='12398' and value=5 and time<to_timestamp('2017-06-06 20:45:00','YYYY-MM-DD hh24:mi:ss')  and date(time)=date('2017-06-06') and flag is null;
update metone set flag=52 where unit_id='SASA_MO1' and type='pm10' and device='12396' and value=4 and date(time)=date('2017-08-12') and time<to_timestamp('2017-08-12 10:45:00','YYYY-MM-DD hh24:mi:ss') and flag is null;
update metone set flag=52 where unit_id='SASA_MO1' and type='pm10' and device='12396' and value=13 and date(time)=date('2017-08-20') and time<to_timestamp('2017-08-20 11:00:00','YYYY-MM-DD hh24:mi:ss') and flag is null;
update  metone set flag=52 where unit_id='SASA_MO3' and type='pm10' and device='12398' and value=7 and date(time)=date('2017-06-13') and time>to_timestamp('2017-06-13 18:30:00','YYYY-MM-DD hh24:mi:ss') and flag is null; -- 11 rows
update  metone set flag=52 where  unit_id='SASA_MO1' and type='pm10' and device='12396' and value=4 and date(time)=date('2017-08-12') and time>to_timestamp('2017-08-12 17:20:00','YYYY-MM-DD hh24:mi:ss') and flag is null; -- 9 rows

alter table aeroqualno2_suspect_verified add column flag integer;
update aeroqualno2_suspect_verified set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update aeroqualno2_suspect_verified set flag=51 where suspect_reason like 'The temperature is %';
update aeroqualno2_suspect_verified set flag=52 where suspect_reason like 'Stuck values';
update aeroqualno2 as m set flag=msv.flag from aeroqualno2_suspect_verified as msv where m.unit_id=msv.unit_id and m.monitorid=msv.monitorid and m.locationid=msv.locationid and m.season=msv.season and m.community=msv.community  and (m.date at time zone 'cst')>=(msv.start_time at time zone 'cst') and (m.date at time zone 'cst')<=(msv.end_time at time zone 'cst') and msv.output='Invalid' and m.flag is null;

alter table aeroqualo3_suspect_verified add column flag integer;
update aeroqualo3_suspect_verified set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update aeroqualo3_suspect_verified set flag=51 where suspect_reason like 'The temperature is %';
update aeroqualo3_suspect_verified set flag=52 where suspect_reason like 'Stuck values';
update aeroqualo3 set flag=null;
update aeroqualo3 as m set flag=msv.flag from aeroqualo3_suspect_verified as msv where m.unit_id=msv.unit_id and m.monitorid=msv.monitorid and m.locationid=msv.locationid and m.season=msv.season and m.community=msv.community  and (m.date at time zone 'cst')>=(msv.start_time at time zone 'cst') and (m.date at time zone 'cst')<=(msv.end_time at time zone 'cst') and msv.output='Invalid' and m.flag is null;


alter table purpleair_suspect_verified add column flag integer;
update purpleair_suspect_verified set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update purpleair_suspect_verified set flag=51 where suspect_reason like 'The temperature is %';
update purpleair_suspect_verified set flag=51 where suspect_reason like 'RH percentage is greater than 80';
update purpleair_suspect_verified set flag=52 where suspect_reason like 'Stuck values';
update purpleair_suspect_verified set flag=50 where suspect_reason like 'Value is in suspicion%';
update purpleair set flag=null;
\copy (select 'update purpleair set flag=50 where device_name='''||device_name||''' and entry_id='||entry_id||' and community='''||community||''' and season='''||season||''' and date_trunc(''minute'',created_at)='''||start_time||''' and flag is null;' from purpleair_suspect_verified where output='Invalid') to 'update_purpleair_flag.csv' (format csv);
update purpleair as p set flag=psv.flag from purpleair_suspect_verified psv where p.device_name=psv.device_name and p.season=psv.season and p.community=psv.community and (p.created_at at time zone 'cst')=(psv.start_time at time zone 'cst') and psv.output='Invalid' and psv.suspect_reason='Value is in suspicion range between 500 and 1000 ugm3';
/* For summer weather data */
update purpleair set flag=51 where device_name='SASA_PA5_LV_S' and community='LV' and season='Summer' and pm25_cf_atm_ugm3=148.77 and flag is null;
update purpleair set flag=51 where device_name='SASA_PA5_LV_S' and community='LV' and season='Summer' and pm25_cf_atm_ugm3=245.41 and flag is null;
update purpleair set flag=null where device_name='SASA_PA5_LV_S' and community='LV' and season='Summer' and pm25_cf_atm_ugm3=139.35 and flag is null and date(created_at)=date('2017-07-04');

alter table airterrier_suspect_verified add column flag integer;
update airterrier_suspect_verified set flag=53 where suspect_reason like 'Value is greater than 3rd standard%';
update airterrier_suspect_verified set flag=51 where suspect_reason like 'The temperature is %';
update airterrier_suspect_verified set flag=51 where suspect_reason like 'RH percentage is greater than 80';
update airterrier_suspect_verified set flag=52 where suspect_reason like 'Stuck values';
update airterrier_suspect_verified set flag=50 where suspect_reason like 'Value is in suspicion%';
update airterrier set flag=null;
\copy (select 'update airterrier set flag='||flag||' where session_title='''||session_title||''' and community='''||community||''' and season='''||season||''' and time>='''||start_time||''' and time<='''||end_time||''' and flag is null;' from airterrier_suspect_verified where output='Invalid') to 'update_airterrier_flag.csv' (format csv);


/* 5.	Data Aggregation for stationary site data and regulatory data
a.	Create data set of sensor data for comparison to regulatory data by computing the following metrics. All averages require 75% completeness of valid data; data aggregates that are incomplete should be flagged (e.g., with QC flag of 7). */
/* i.	Ozone – 1-hr average and daily maximum 8-hr average (based on rolling 8-hr average) */
alter table epa_daily_o3 add column max_8hour_avg  numeric;
create table epa_8hour_o3_max as select date(date_local),max(mean_excluding_all_flagged_data),latitude,longitude,count(*) from epa_8hour_o3 group by 1,latitude,longitude order by 1;
update epa_daily_o3 daily set max_8hour_avg=max from epa_8hour_o3_max as hour8 where date(date_local)=hour8.date and daily.longitude=hour8.longitude and daily.latitude=hour8.latitude;
/* ii.	NO, NO2, NOx – 1-hr averages */
/* iii.	PM2.5, PM10 – 1-hr, daily (24-hr) averages */
drop table if exists sasa_pm25_1hr;
create table sasa_pm25_1hr	as
select unit_id, season, community, round(avg(value)) AS avg_value, max(value) AS max_value, min(value) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min' AS time from metone where flag is distinct from 90 and type='pm25' group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
insert into sasa_pm25_1hr
select device_name, season, community, round(avg(pm25_cf_atm_ugm3)) AS avg_value, max(pm25_cf_atm_ugm3) AS max_value, min(pm25_cf_atm_ugm3) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', created_at) + date_part('minute', created_at)::int /60 * interval '60 min' AS time from purpleair where flag is distinct from 90 group by 8, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by device_name,community,season,8;
drop table if exists sasa_pm25_24hr;
create table sasa_pm25_24hr	as
select unit_id, season, community, round(avg(value)) AS avg_value, max(value) AS max_value, min(value) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(time) AS time from metone where flag is distinct from 90 and type='pm25' group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
insert into sasa_pm25_24hr
select device_name, season, community, round(avg(pm25_cf_atm_ugm3)) AS avg_value, max(pm25_cf_atm_ugm3) AS max_value, min(pm25_cf_atm_ugm3) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(created_at) AS time from purpleair where flag is distinct from 90 group by 8, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by device_name,community,season,8;

drop table if exists sasa_pm10_1hr;
create table sasa_pm10_1hr	as
select unit_id, season, community, round(avg(value)) AS avg_value, max(value) AS max_value, min(value) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min' AS time from metone where flag is distinct from 90 and type='pm10' group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
insert into sasa_pm10_1hr
select device_name, season, community, round(avg(pm10_cf_atm_ugm3)) AS avg_value, max(pm10_cf_atm_ugm3) AS max_value, min(pm10_cf_atm_ugm3) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', created_at) + date_part('minute', created_at)::int /60 * interval '60 min' AS time from purpleair where flag is distinct from 90 group by 8, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by device_name,community,season,8;
drop table if exists sasa_pm10_24hr;
create table sasa_pm10_24hr	as
select unit_id, season, community, round(avg(value)) AS avg_value, max(value) AS max_value, min(value) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(time) AS time from metone where flag is distinct from 90 and type='pm10' group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
insert into sasa_pm10_24hr
select device_name, season, community, round(avg(pm10_cf_atm_ugm3)) AS avg_value, max(pm10_cf_atm_ugm3) AS max_value, min(pm10_cf_atm_ugm3) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(created_at) AS time from purpleair where flag is distinct from 90 group by 8, device_name, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by device_name,community,season,8;

drop table if exists sasa_no2_1hr;
create table sasa_no2_1hr	as
select unit_id, season, community, round(avg(no2ppm)::numeric,3) AS avg_value, max(no2ppm) AS max_value, min(no2ppm) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min' AS time from aeroqualno2 where flag is distinct from 90 group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
drop table if exists sasa_no2_24hr;
create table sasa_no2_24hr	as
select unit_id, season, community, round(avg(no2ppm)::numeric,3) AS avg_value, max(no2ppm) AS max_value, min(no2ppm) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(date) AS time from aeroqualno2 where flag is distinct from 90 group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;

drop table if exists sasa_o3_1hr;
create table sasa_o3_1hr	as
select unit_id, season, community, round(avg(o3ppm)::numeric,3) AS avg_value, max(o3ppm) AS max_value, min(o3ppm) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min' AS time from aeroqualo3 where flag is distinct from 90 group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
drop table if exists sasa_o3_24hr;
create table sasa_o3_24hr	as
select unit_id, season, community, round(avg(o3ppm)::numeric,3) AS avg_value, max(o3ppm) AS max_value, min(o3ppm) AS min_value, sum(case when flag is null then 1 else 0 end) AS no_of_readings,date(date) AS time from aeroqualo3 where flag is distinct from 90 group by 8, unit_id, season, community having sum(case when flag is distinct from 90 then 1 else 0 end)>1 and (sum(case when flag is null then 1 else 0 end)*100)/sum(case when flag is distinct from 90 then 1 else 0 end)>= 75 order by unit_id,community,season,8;
drop table if exits sasa_o3_8hr;
/* creates 8 hour running average of ozone */
create table sasa_o3_8hr as
select sa.unit_id,sa.season,sa.community,sa.time,round(avg(sb.avg_value)::numeric,3) max_avg from sasa_o3_1hr sa, sasa_o3_1hr sb where sa.unit_id=sb.unit_id and sb.season=sa.season and sa.community=sb.community and sb.time<=sa.time and sb.time>=sa.time - interval '7' hour group by sa.unit_id,sa.season,sa.community,sa.time having count(sb.*)=8 order by sa.unit_id,sa.season,sa.community,sa.time;

/* update the falg to 7 which has completeness less than 75% */
update metone set flag=7 where (date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min') in (select date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min' AS time from metone where flag is distinct from 90 and type='pm25' group by 1, unit_id, season, community having (sum(case when flag is null then 1 else 0 end)*100)/count(*)< 75) and flag is null;
update purpleair set flag=7 where (date_trunc('hour', created_at) + date_part('minute', created_at)::int /60 * interval '60 min') in (select date_trunc('hour', created_at) + date_part('minute', created_at)::int /60 * interval '60 min' AS time from purpleair where flag is distinct from 90 group by 1, device_name, season, community having (sum(case when flag is null then 1 else 0 end)*100)/count(*)< 75) and flag is null;
update aeroqualo3 set flag=7 where (date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min') in (select date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min' AS time from aeroqualo3 where flag is distinct from 90 group by 1, unit_id, season, community having (sum(case when flag is null then 1 else 0 end)*100)/count(*)< 75) and flag is null;
update aeroqualno2 set flag=7 where (date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min') in (select date_trunc('hour', date) + date_part('minute', date)::int /60 * interval '60 min' AS time from aeroqualno2 where flag is distinct from 90 group by 1, unit_id, season, community having (sum(case when flag is null then 1 else 0 end)*100)/count(*)< 75) and flag is null;
update metone set flag=7 where (date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min') in (select date_trunc('hour', time) + date_part('minute', time)::int /60 * interval '60 min' AS time from metone where flag is distinct from 90 and type='pm10' group by 1, unit_id, season, community having (sum(case when flag is null then 1 else 0 end)*100)/count(*)< 75) and flag is null;

/* b.	For each sensor deployment, identify the closest regulator monitor for O3, NO2 PM2.5 and PM10, and develop (if not already provided by EPA) daily 8-hr maximum for O3, and daily PM2.5 and PM10 average concentrations */

/* 6.	Data Summaries
a.	Compute concentration statistics including mean; median; 25th, 75th, 99th percentiles; minimum; maximum for each parameter/sensor pairing. */
drop table if exists sasa_pm25_summary;
create table sasa_pm25_summary as
select unit_id,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(value),2) average,round(median(value),2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY value) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY value) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY value) percentile_99th,min(value) min_value,max(value) max_value from metone where type='pm25' and flag is distinct from 90 group by unit_id,season,community;
insert into sasa_pm25_summary
select device_name,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(pm25_cf_atm_ugm3)::numeric,2) average,round(median(pm25_cf_atm_ugm3::numeric)::numeric,2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY pm25_cf_atm_ugm3) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY pm25_cf_atm_ugm3) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY pm25_cf_atm_ugm3) percentile_99th,min(pm25_cf_atm_ugm3) min_value,max(pm25_cf_atm_ugm3) max_value from purpleair where flag is distinct from 90 group by device_name,season,community;

drop table if exists sasa_pm10_summary;
create table sasa_pm10_summary as
select unit_id,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(value),2) average,round(median(value),2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY value) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY value) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY value) percentile_99th,min(value) min_value,max(value) max_value from metone where type='pm10' and flag is distinct from 90 group by unit_id,season,community;
insert into sasa_pm10_summary
select device_name,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(pm10_cf_atm_ugm3)::numeric,2) average,round(median(pm10_cf_atm_ugm3::numeric)::numeric,2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY pm10_cf_atm_ugm3) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY pm10_cf_atm_ugm3) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY pm10_cf_atm_ugm3) percentile_99th,min(pm10_cf_atm_ugm3) min_value,max(pm10_cf_atm_ugm3) max_value from purpleair where flag is distinct from 90 group by device_name,season,community;

drop table if exists sasa_no2_summary;
create table sasa_no2_summary as
select unit_id,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(no2ppm)::numeric,2) average,round(median(no2ppm::numeric)::numeric,2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY no2ppm) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY no2ppm) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY no2ppm) percentile_99th,min(no2ppm) min_value,max(no2ppm) max_value from aeroqualno2 where flag is distinct from 90 group by unit_id,season,community;
drop table if exists sasa_o3_summary;
create table sasa_o3_summary as
select unit_id,season,community,count(*) total_readings,sum(case when flag is null then 1 else 0 end) as valid_readings,round(sum(case when flag is null then 1 else 0 end)*100/count(*)) completeness,round(avg(o3ppm)::numeric,2) average,round(median(o3ppm::numeric)::numeric,2) median,percentile_disc(0.25) WITHIN GROUP (ORDER BY o3ppm) percentile_25th,percentile_disc(0.75) WITHIN GROUP (ORDER BY o3ppm) percentile_75th,percentile_disc(0.99) WITHIN GROUP (ORDER BY o3ppm) percentile_99th,min(o3ppm) min_value,max(o3ppm) max_value from aeroqualo3 where flag is distinct from 90 group by unit_id,season,community;


/* b.	For each community, create scatter plot matrices of stationary data (1 matrix for each air quality parameter) using the 1-hour averages, to compare each monitor to the other monitors. */

 /* Create a summary table of all the stationary location season, community, earliest_reading_date, latest_reading_date */
drop table stationary_summary;
create table stationary_summary as select device_name sensor_name,community,season,'purpleair'::varchar source ,min(created_at) earliest_reading_date ,max(created_at) latest_reading_date from purpleair where flag is null group by device_name,community,season order by 3,2,1;
insert into stationary_summary select unit_id,community,season,'metone' source ,min(time) earliest_reading_date ,max(time) latest_reading_date from metone where flag is null group by unit_id,community,season order by 3,2,1;
insert into stationary_summary select unit_id,community,season,'aeroqual_no2' source ,min(date) earliest_reading_date ,max(date) latest_reading_date from aeroqualno2 where flag is null group by unit_id,community,season order by 3,2,1;
insert into stationary_summary select unit_id,community,season,'aeroqual_o3' source ,min(date) earliest_reading_date ,max(date) latest_reading_date from aeroqualo3 where flag is null group by unit_id,community,season order by 3,2,1;

create table stationarylocations_new as select unit_id,latitude,longitude,address,stationarylocations.community,stationary_summary.season,source,earliest_reading_date,latest_reading_date from stationary_summary ,stationarylocations where stationarylocations.community=stationary_summary.community and stationarylocations.unit_id=stationary_summary.sensor_name;
