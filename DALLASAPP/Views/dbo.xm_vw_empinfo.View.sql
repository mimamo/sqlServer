USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xm_vw_empinfo]    Script Date: 12/21/2015 13:44:22 ******/
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
-- MAG 9/22/09 modified above view and saved under different name to show all rates for   --
-- all effective dates                                                                    --
------------------------------------------------------------------------------------------------------------------------


create view [dbo].[xm_vw_empinfo] 
as

select 
	a.emp_name employee_name,
	a.date_hired,
    d.effect_date,
	d.labor_class_cd labor_class,
	c.emp_name supervisor,
	d.labor_rate hourly_rate,
	d.ep_id06 weekly_salary,
	a.emp_status
from
	pjemploy a
left join
	pjemploy c
on
	a.manager1 = c.employee
left join
	pjemppjt d
on
	a.employee = d.employee
GO
