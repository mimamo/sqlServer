USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xq_vw_xqesl00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 04/27/09                                                                       --                                                                          --
-- Integer Dallas Employee Salary/Labor Class Report XQESL00.rpt                                      --
-- This Report was designed to show all/or active employee information in pjemploy table) --
-- such as Employee name, Hire date, Labor class, Supervisor, Hourly rate, Weekly Salary  --
-- Cloned the Queue XQEMP00 report to add some fields.  Created this view rather than modify the Queue view
------------------------------------------------------------------------------------------------------------------------


CREATE view [dbo].[xq_vw_xqesl00] 
as
select
    a.employee, 
	a.emp_name employee_name,
	a.date_hired,
	d.labor_class,
	c.emp_name supervisor,
    f.emp_name manager,
	d.hourly_rate,
	d.weekly_salary,
	a.emp_status,
    a.gl_subacct,
    e.code_value_desc labor_class_desc
from
	pjemploy a
left join
	pjemploy c
on
	a.manager1 = c.employee
left join
    pjemploy f
on
    a.manager2 = f.employee
left join
	xq_vw_rateinfo d
on
	a.employee = d.employee
left outer join
    xqLaborClasses e
on
    d.labor_class = e.code_value
GO
