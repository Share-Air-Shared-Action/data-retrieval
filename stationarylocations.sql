-- Build stationarylocations

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ1', 42.13999624, -87.79922692, 'NB');

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ2', 42.13999623, -87.79922692, 'NB');

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ1', 41.8609802, -87.6280025, 'SL');

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ2', 41.8609802, -87.6280025, 'SL');

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ1', 41.653887, -87.602826, 'PC');

INSERT INTO stationarylocations(unit_id, latitude, longitude, community)
  VALUES('SASA_AQ2', 41.653887, -87.602826, 'PC');

INSERT INTO stationarylocations(unit_id,latitude,longitude,address,dateinstalled,community) VALUES('SASA_PA3B',41.843557,-87.732057,'2616 S. Kildaire', to_date('2017-04-15','YYYY-MM-DD')    ,'LV');
INSERT INTO stationarylocations(unit_id,latitude,longitude,address,dateinstalled,community) VALUES('SASA_PA4B',41.843557,-87.732057,'2616 S. Kildaire', to_date('2017-04-15','YYYY-MM-DD')    ,'LV');
INSERT INTO stationarylocations(unit_id,latitude,longitude,address,dateinstalled,community) VALUES('SASA_PA5B',41.84962,-87.703686,'2311 S. Troy', to_date('2017-04-17','YYYY-MM-DD')    ,'LV');
INSERT INTO stationarylocations(unit_id,latitude,longitude,address,dateinstalled,community) VALUES('SASA_PA2B',41.842145,-87.724138,'2707 S. Pulaski',to_date('2017-04-17','YYYY-MM-DD'),'LV');
INSERT INTO stationarylocations(unit_id,latitude,longitude,community) VALUES ('SASA_PA10_SL_SB',41.868884,-87.629213,'SL');
INSERT INTO stationarylocations(unit_id,latitude,longitude,community) VALUES ('SASA_PA13_SL_SB',41.867463,-87.627174,'SL');
INSERT INTO stationarylocations(unit_id,latitude,longitude,community) VALUES ('SASA_PA15_SL_SB',41.868808,-87.629388,'SL');
INSERT INTO stationarylocations(unit_id,latitude,longitude,community) VALUES ('SASA_PA16_SL_SB',41.864197,-87.630135,'SL');
-- removing incorrect two stationary locations for SASA_PA2 and SASA_PA2B and inserting with the correct latlong location
delete from stationarylocations where unit_id='SASA_PA2B' or unit_id='SASA_PA2';
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA2',41.84061,-87.734597,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA2B',41.84061,-87.734597,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA7',41.850941,-87.684403,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA7B',41.850941,-87.684403,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA8',41.849809,-87.696619,'LV');
insert into stationarylocations(unit_id,latitude,longitude,community) values('SASA_PA8B',41.849809,-87.696619,'LV');
update stationarylocations set latitude=41.701407,longitude=-87.542820,address='10644 S Mackinaw Ave' where unit_id in ('SASA_PA7_SE_W','SASA_PA7_SE_WB') and community='SE' and season='Winter' and source='purpleair';
insert into stationarylocations(unit_id,latitude,longitude,address,community,season,source) values ('SASA_PA7_SL_W',41.868877, -87.629415,'1138 South Plymouth Court, Chicago, IL, USA','SL','Winter','purpleair');
update stationarylocations set latest_reading_date='2017-09-01 11:50:33-05',earliest_reading_date='2017-08-25 14:41:32-05' where unit_id='SASA_PA3_PC_S';
update stationarylocations set latest_reading_date='2017-09-20 17:45:18-05',earliest_reading_date='2017-07-27 11:48:35-05' where unit_id='SASA_PA10_PC_S';
update stationarylocations set latest_reading_date='2018-05-31 18:59:33-05',earliest_reading_date='2018-04-13 11:40:30-05' where unit_id='SASA_PA7_SL_W';
