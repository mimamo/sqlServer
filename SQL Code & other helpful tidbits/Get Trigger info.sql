-- Get all of the triggers in the system
select name as 'Trigger', object_name(parent_obj) as 'Table'
from sysobjects
where xtype = 'TR'
order by name 

-- get script for the trigger
exec sp_helptext [trigger name]

