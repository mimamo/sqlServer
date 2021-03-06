USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmfwk711]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xmfwk711] 
as

select 
  
  e.emp_name,
  s.descr Dept_Name,
  m.emp_title,
  FWK711BEVPWC_Hrs =
    Case
      When
        substring(t.project,1,6) like 'FWK711' or
        substring(t.project,1,6) like 'FWKBEV' or
        substring(t.project,1,6) like 'FWKPWC' Then t.units
      Else 0 
    End,
  Other_Hrs =
    Case
      When 
        substring(t.project,1,6) not like 'FWK711' and
        substring(t.project,1,6) not like 'FWKBEV' and
        substring(t.project,1,6) not like 'FWKPWC' and
        substring(t.project,1,3) not like 'INT' Then t.units
      Else 0
    End,
  INTGENEMP09_Hrs =
    Case
      When
        t.project = 'INTGEN02010AG' and
        t.pjt_entity = 'EMP09' Then t.units
      Else 0
    End
  
from pjtran t
  left outer join pjemploy e
  on t.employee = e.employee
  left outer join xmluc_Emp_Title m
  on t.employee = m.employee
  left outer join SubAcct s
  on e.gl_subacct = s.sub

where t.fiscalno >= '201001' and 
  t.fiscalno <= '201012' and
  t.acct = 'DIRECT SALARY'

/*  and r.ri_id = '727'  */
GO
