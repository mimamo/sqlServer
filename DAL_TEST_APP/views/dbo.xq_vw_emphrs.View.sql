USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_vw_emphrs]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_vw_emphrs]

as
select
	a.employee, d.emp_name, a.fiscalno, sum(a.units) tot_hrs, b.customer, c.name custname
from
	pjtran a
left join
	pjproj b
on
	a.project = b.project
left join
	customer c
on
	b.customer = c.custid
left join
	pjemploy d
on
	a.employee = d.employee
where
	a.acct = 'DIRECT SALARY'
and
	d.emp_name is not null
and
	c.name is not null
group by
	a.employee, d.emp_name, a.fiscalno, b.customer, c.name
GO
