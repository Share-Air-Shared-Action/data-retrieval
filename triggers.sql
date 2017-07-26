
update aeroqualno2 set unit_id='SASA_AQ1' where unit_id IS NULL;
update aeroqualo3 set unit_id='SASA_AQ2' where unit_id IS NULL;

update aeroqualno2 set season='Pilot'  where season IS NULL and (date>= '2017-04-17 00:00:00-00' and date<= '2017-04-26 00:00:00-00');
update aeroqualno2 set season='Summer' where season IS NULL and (date> '2017-06-05 00:00:00-00' and date<= '2017-10-01 00:00:00-00');
update aeroqualno2 set season='Winter' where season IS NULL and (date> '2017-10-01 00:00:00-00');

update metone set season='Pilot' where season IS NULL and (time>= '2017-04-17 00:00:00-00' and time<= '2017-04-26 00:00:00-00');
update metone set season='Summer' where  season IS NULL and (time> '2017-06-05 00:00:00-00' and time<= '2017-10-01 00:00:00-00');
update metone set season='Winter' where season IS NULL and (time> '2017-10-01 00:00:00-00');

update metone set type='pm10' where type='conc' and unit_id='SASA_MO3';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO1';
update metone set type='pm25' where type='conc' and unit_id='SASA_MO2';

update metone set community='LV' where community IS NULL and (time>= '2017-06-05 00:00:00-00' and time < '2017-07-01 00:00:00-00');
update metone set community='SE' where community IS NULL and (time>= '2017-07-01 00:00:00-00' and time <= '2017-07-31 00:00:00-00');

update airterrier set season='Pilot' where season IS NULL and (time>= '2017-04-17 00:00:00-00' and time<= '2017-04-30 00:00:00-00');
update airterrier set season='Summer' where season IS NULL and ( time> '2017-06-05 00:00:00-00' and time<= '2017-10-01 00:00:00-00');
update airterrier set season='Winter' where  season IS NULL and (time> '2017-10-01 00:00:00-00');

update aeroqualo3 set season='Pilot' where season IS NULL and (date>= '2017-04-17 00:00:00-00' and date<= '2017-04-26 00:00:00-00');
update aeroqualo3 set season='Summer' where season IS NULL and (date> '2017-06-05 00:00:00-00' and date<= '2017-10-01 00:00:00-00');
update aeroqualo3 set season='Winter' where season IS NULL and (date> '2017-10-01 00:00:00-00');

update purpleairprimary set season= 'Pilot' where season IS NULL and (created_at>='2017-04-17 00:00:00-00' and created_at<= '2017-04-26 00:00:00-00');
update purpleairprimary set season= 'Summer'  where season IS NULL and (created_at> '2017-06-05 00:00:00-00' and  created_at<= '2017-10-01 00:00:00-00');
update purpleairprimary set season= 'Winter' where season IS NULL and (created_at> '2017-10-01 00:00:00-00');

update purpleairprimary set community='LV' where community IS NULL and (time>= '2017-06-05 00:00:00-00' and time < '2017-07-01 00:00:00-00');
update purpleairprimary set community='SE' where community IS NULL and (time>= '2017-07-01 00:00:00-00' and time <= '2017-07-31 00:00:00-00');

update purpleairsecondary set season='Pilot' where  season IS NULL and (created_at>='2017-04-17 00:00:00-00' and created_at<= '2017-04-26 00:00:00-00');
update purpleairsecondary set season='Summer' where season IS NULL and (created_at> '2017-06-05 00:00:00-00' and  created_at<= '2017-10-01 00:00:00-00');
update purpleairsecondary set season='Winter' where season IS NULL and (created_at> '2017-10-01 00:00:00-00');
