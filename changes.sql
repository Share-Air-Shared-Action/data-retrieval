-- This file contains changes that we have made to data so that if data needs to be reloaded we can re-apply those changes
-- It is meant to only be run when a change is made or when data is reloaded.


-- Airbeam/Terrier
update airterrier set session_title='test_pc1_0726pm' where session_title='pc1_0726pm';
update airterrier set session_title='LV7_0706PM' where session_title='Queen Elizabeth Session';
update airterrier set session_title='LV8_0622PM' where session_title='LV8_0622';
update airterrier set session_title='test_pc1_0727am' where session_title='pc1_0806am';
update airterrier set session_title='AG00_0822PM' where session_title=' test sl1';
update airterrier set session_title='LV_02017PM' where session_title=' test2';
update airterrier set session_title='LV00_0407PM' where session_title=' nowifi';
update airterrier set session_title='LV00_0412AM' where session_title=' try';
update airterrier set session_title='LV00_0606AM' where session_title=' air casting test';
update airterrier set session_title='LV04_0322PM' where session_title=' route 4 rckc';
update airterrier set session_title='NB00_0403PM' where session_title=' test4landmark';
update airterrier set session_title='NB02_1019PM' where session_title=' C b see see e';
update airterrier set session_title='NB02_1019PM' where session_title=' xathi2';
update airterrier set session_title='NB02_1019PM' where session_title=' ftjui';
update airterrier set session_title='NB08_1019PM' where session_title like ' n be map%';

-- Renames on PC per PCRAirMonitoringReview.xlsx
update airterrier set session_title='PC1_0824AM' where session_title='pc1_0824_2017';
update airterrier set session_title='PC1_0814PM' where session_title='pc1_0814_am';
update airterrier set session_title='PC1_0816PM' where session_title='pc1_0816_17';
update airterrier set session_title='PC1_0816PM' where session_title='pc1_0816am';
update airterrier set session_title='PC1_0818PM' where session_title='pc1_0818pm';
update airterrier set session_title='PC1_0821PM' where session_title='pc1_0821_2017';
update airterrier set session_title='PC1_0825PM' where session_title='pc1_0825_2017';
update airterrier set session_title='PC2_0814PM' where session_title='pc2_0814_am';
update airterrier set session_title='PC2_0818PM' where session_title='pc2_0818pmt';
update airterrier set session_title='PC2_0829PM' where session_title='pc5_0829pm';
update airterrier set session_title='PC2_0831PM' where session_title='pc5_831pm';
update airterrier set session_title='PC3_0814AM' where session_title='pc3_0814_am';
update airterrier set session_title='PC3_0818AM' where session_title='pc3_0818am';
update airterrier set session_title='PC3_0821PM' where session_title='pc3_0821am';
update airterrier set session_title='PC3_0825PM' where session_title='pc3_0825';
update airterrier set session_title='PC3_0828PM' where session_title='pc3_0828pmt';
update airterrier set session_title='PC3_0828PM' where session_title='pc3_0828pmt';
update airterrier set session_title='PC3_0830PM' where session_title='pc3_0830';
update airterrier set session_title='PC3_0831PM' where session_title='pc3_0831';
update airterrier set session_title='PC4_0818AM' where session_title='pc4_0818am';
update airterrier set session_title='PC4_0817PM' where session_title='pc4_0817pm';
update airterrier set session_title='PC4_0818PM' where session_title='pc4_0818pmt';
update airterrier set session_title='PC4_0821AM' where session_title='pc4_0821pm';
update airterrier set session_title='PC4_0823PM' where session_title='pc4_0823pm';
update airterrier set session_title='PC4_0825PM' where session_title='pc4_0825pm';
-- For SE Community
update airterrier set session_title='SE1_0319AM' where session_title='se_01031918am';
update airterrier set session_title='SE1_0321AM' where session_title='se_032118am';
update airterrier set session_title='SE1_0323AM' where session_title='se1032318am';
update airterrier set session_title='SE1_0326AM' where session_title='SE1_032618am';
update airterrier set session_title='SE1_0328AM' where session_title='Se1_032818am';
update airterrier set session_title='SE4_0320AM' where session_title='se403/20/18';
update airterrier set session_title='SE4_0322AM' where session_title='se4_03/22/18';
update airterrier set session_title='SE5_0320AM' where session_title='se5 103 Torrence 10:20 thru 11:00 am';
update airterrier set session_title='SE5_0322AM' where session_title='see 5 103 torrence';
--For SL community
update airterrier set session_title='SL1_0423AM' where session_title='sl1_0423am2';
update airterrier set session_title='SL2_0418AM' where session_title='SL2_04/18AM';
update airterrier set session_title='SL2_0418AM' where session_title='SL2_4-18_C1';
update airterrier set session_title='SL2_0420AM' where session_title='sl2_0420am';
update airterrier set session_title='SL2_0420AM' where session_title='sl2_0420am2';
update airterrier set session_title='SL2_0425_AMT' where session_title='sl2_0425amt2';
update airterrier set session_title='SL3_0410AM' where session_title='SL3_0410AM2';
update airterrier set session_title='SL3_0410AM' where session_title='SL3_0410AM3';
update airterrier set session_title='SL3_0423PM' where session_title='sl3_042318pm';
update airterrier set session_title='SL3_0425AMT' where session_title='sl3_0425amt2';
update airterrier set session_title='SL5_0411AM' where session_title='SL5_0411AMTEST';
update airterrier set session_title='SL5_0416PM' where session_title='SL5_041618PM';
--For PC Community
update airterrier set session_title='PC00_0228AM' where session_title='pcc feb28';
update airterrier set session_title='PC9_0504PMT' where session_title='pc9_0504pmt2';
update airterrier set session_title='PC9_0504PMT' where session_title='pc9_0504pmt3';


-- Fix Purple Air that wasn't re-registered
update purpleairprimary set device_name='SASA_PA2_PC_S' where device_name='SASA_PA6_SE_S6' and created_at > '2017-08-10 00:00:00-05';
update purpleairprimary set device_name='SASA_PA2_PC_SB' where device_name='SASA_PA6_SE_S6B' and created_at > '2017-08-10 00:00:00-05';
