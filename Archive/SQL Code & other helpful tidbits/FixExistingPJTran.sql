-- Run against pjtranex to identify a collumn that is not used
SELECT DISTINCT tr_id20 FROM PJTRANEX

-- update the table so that the trigger runs 
-- just have to run this in the database after the trigger is created
UPDATE PJTRANEX set tr_id20 = '   '
