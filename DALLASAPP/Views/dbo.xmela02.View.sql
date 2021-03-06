USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmela02]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmela02] 
as
select 
  r.ri_id,  
  e.emp_name,
  t.employee,
  s.descr Dept_Name,
  m.emp_title,
  Client_Hrs =
    Case
      When
        substring(t.project,1,3) not like 'INT' and
        substring(t.project,1,3) not like 'NBZ' and
        substring(t.project,1,3) not like 'GEN' and
        substring(t.project,4,3) not like 'INT' and
        substring(t.project,4,3) not like 'GEN' and
        substring(t.project,4,3) not like 'NBZ' and
        substring(t.project,4,3) not like 'SEA' Then t.units
      Else 0  
    End,
  Internal_Hrs = 
    Case
      When
        substring(t.project,1,3) like 'INT' or
        substring(t.project,1,3) like 'NBZ' or
        substring(t.project,1,3) like 'GEN' or
        substring(t.project,4,3) like 'INT' or
        substring(t.project,4,3) like 'GEN' or
        substring(t.project,4,3) like 'NBZ' or
        substring(t.project,4,3) like 'SEA' Then t.units
      Else 0
    End

from rptruntime r
  cross join pjtran t
  left outer join pjemploy e
  on t.employee = e.employee
  left outer join xmluc_Emp_Title m
  on t.employee = m.employee
  left outer join SubAcct s
  on e.gl_subacct = s.sub

where t.fiscalno >= r.begpernbr and 
  t.fiscalno <= r.endpernbr and
  t.acct = 'DIRECT SALARY' and
  LTRIM(t.employee) <> ''

/*  and r.ri_id = '727'  */
GO
