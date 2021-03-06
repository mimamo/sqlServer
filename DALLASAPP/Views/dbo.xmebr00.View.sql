USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmebr00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/26/10                                                                                    --                                                                          --
-- Created as the primary view for the Labor Class/Employee Bill Rate Report (XM.EBR.00)          --
-- This view was designed to show all/or active employee information in pjemploy table            --
-- such as Employee name, Hire date, Labor class, Supervisor and Alloc Bill Rate based on         --
-- the current Labor Class for that employee                                                      --
-- Cloned the Queue XQ_VW_XQESL00 as XMEBR00 and created associated subviews                      --
-- MAG 9/29/10: Added field gl_subacct                                                            --
--------------------------------------------------------------------------------------------------------------------


CREATE view [dbo].[xmebr00] 
as
select
    a.employee, 
	a.emp_name employee_name,
	a.date_hired,
	d.labor_class,
	c.emp_name supervisor,
    f.emp_name manager,
	a.emp_status,
    a.gl_subacct,
    e.code_value_desc labor_class_desc,
    b.bill_effect_date,
    ISNULL(b.billing_rate,0) billing_rate
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
	xmemplabc d
on
	a.employee = d.employee
left outer join
    xqLaborClasses e
on
    d.labor_class = e.code_value
left outer join
    xmbillrate b
on
    d.labor_class = b.labor_class
GO
