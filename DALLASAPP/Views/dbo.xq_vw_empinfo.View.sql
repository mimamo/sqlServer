USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xq_vw_empinfo]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- Queue Associates                                                                       --
-- SS 6/6/08                                                                              --
-- Integer Dallas Employee Salary Report xqemp00.rpt                                      --
-- This Report was designed to show all/or active employee information in pjemploy table) --
-- such as Employee name, Hire date, Labor class, Supervisor, Hourly rate, Weekly Salary  --
------------------------------------------------------------------------------------------------------------------------


create view [dbo].[xq_vw_empinfo] 
as

select 
	a.emp_name employee_name,
	a.date_hired,
	d.labor_class,
	c.emp_name supervisor,
	d.hourly_rate,
	d.weekly_salary,
	a.emp_status
from
	pjemploy a
left join
	pjemploy c
on
	a.manager1 = c.employee
left join
	xq_vw_rateinfo d
on
	a.employee = d.employee
GO
