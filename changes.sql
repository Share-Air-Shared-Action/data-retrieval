-- This file contains changes that we have made to data so that if data needs to be reloaded we can re-apply those changes
-- It is meant to only be run when a change is made or when data is reloaded.


-- Airbeam/Terrier
update airterrier set session_title='test_pc1_0726pm' where session_title='pc1_0726pm';
update airterrier set session_title='LV7_0706PM' where session_title='Queen Elizabeth Session';
update airterrier set session_title='LV8_0622PM' where session_title='LV8_0622';
update airterrier set session_title='test_pc1_0727am' where session_title='pc1_0806am';

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
update airterrier set session_title='PC4_0830PM' where session_title='pc4_0830_am';


-- Fix Purple Air that wasn't re-registered
update purpleairprimary set device_name='SASA_PA2_PC_S' where device_name='SASA_PA6_SE_S6' and created_at > '2017-08-10 00:00:00-05';
update purpleairprimary set device_name='SASA_PA2_PC_SB' where device_name='SASA_PA6_SE_S6B' and created_at > '2017-08-10 00:00:00-05';
