USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xre_tm900]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xre_tm900] as
select 
e.emp_name,
t.amount,
t.acct, 
e.gl_subacct,
e.employee,
c.code_value_desc,
s.descr,
t.fiscalno,
c.code_type
from pjtran t
right outer join pjemploy e on t.employee=e.employee
join subacct s on e.gl_subacct=s.sub
left outer join pjcode c on t.tr_id05=c.code_value 
where 
isnull(c.code_type,'') in ('LABC','')
GO
