-- This file contains changes that we have made to data so that if data needs to be reloaded we can re-apply those changes
-- It is meant to only be run when a change is made or when data is reloaded.


-- Airbeam/Terrier
update airterrier set session_title='test_pc1_0726pm' where session_title='pc1_0726pm';
update airterrier set session_title='LV7_0706PM' where session_title='Queen Elizabeth Session';
update airterrier set session_title='LV8_0622PM' where session_title='LV8_0622';
