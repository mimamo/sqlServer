USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BridgeSupervisorNameFromEmployee]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BridgeSupervisorNameFromEmployee]

AS


SELECT ltrim(a.last_name) + '~' + ltrim(a.first_name) as 'brdg_employee_name'
, CASE WHEN a.username = ''
		THEN lower(ltrim(left(first_name, 1)) + ltrim(a.last_name))
		ELSE a.username end as 'brdg_employee_username'
, CASE WHEN a.username = ''
		THEN COALESCE((SELECT emp_name FROM PJEMPLOY WHERE employee = lower(ltrim(left(first_name, 1)) + ltrim(a.last_name))), (SELECT emp_name FROM SQL1.STREETSOURCEAPP.dbo.PJEMPLOY WHERE employee = lower(ltrim(left(first_name, 1)) + ltrim(a.last_name))), 'Not_In_DSL')
		ELSE COALESCE(e3.emp_name, e4.emp_name, 'Not_In_DSL') end as 'dsl_employee_name'
, ISNULL(a.supervisor_id, 0) as 'brdg_emp_supervisor_id'
, ISNULL(b.username, 'N/A') as 'dsl_supervisor_username'
, COALESCE(e1.emp_name, e2.emp_name, 'Not_In_DSL') as 'dsl_supervisor_name'
FROM (SELECT * FROM OPENQUERY([xRHSQL.bridge],'SELECT DISTINCT first_name, last_name, username, supervisor_id FROM bridge.associate WHERE termination_date = ''0000-00-00''')) a 
	LEFT JOIN (SELECT * FROM OPENQUERY([xRHSQL.bridge],'SELECT DISTINCT id, username FROM bridge.associate')) b ON a.supervisor_id = b.id
	LEFT JOIN (SELECT emp_name, employee FROM PJEMPLOY WHERE emp_type_cd <> 'PROD') e1 ON b.username = e1.employee
	LEFT JOIN (SELECT emp_name, employee FROM STREETSOURCEAPP.dbo.PJEMPLOY WHERE emp_type_cd <> 'PROD') e2 ON b.username = e2.employee
	LEFT JOIN (SELECT emp_name, employee FROM PJEMPLOY WHERE emp_type_cd <> 'PROD') e3 ON a.username = e3.employee
	LEFT JOIN (SELECT emp_name, employee FROM STREETSOURCEAPP.dbo.PJEMPLOY WHERE emp_type_cd <> 'PROD') e4 ON a.username = e4.employee
GO
