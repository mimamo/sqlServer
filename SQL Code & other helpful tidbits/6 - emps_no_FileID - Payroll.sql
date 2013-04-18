-- Finad all of the active employees with no file ID assigned to them in dynamics
select employee, emp_name, user2 as FileID, emp_status, date_hired from PJEMPLOY where emp_type_cd <> 'PROD' and emp_status = 'A' and user2 =''

-- Find changes to the log for the pjemploy table
--select * from xAPJEMPLOY where employee IN ('bconnor','mBrumbach','aluu')