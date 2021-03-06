USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmelc01]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmelc01] 
as

select 
  r.ri_id,  
  e.emp_name,
  s.descr Dept_Name,
  m.emp_title,
  Client_Hrs =
    Case
      When
        LTRIM(r.LongAnswer00) = '' Then 0
      Else
        Case
          When
            (substring(t.project,1,3) = RTRIM(r.LongAnswer00) and
            (substring(t.project,4,3) = RTRIM(r.LongAnswer01) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer02) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer03) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer04))) or

            (substring(t.project,1,3) = RTRIM(r.LongAnswer00) and
            RTRIM(r.LongAnswer01) = '' and
            RTRIM(r.LongAnswer02) = '' and
            RTRIM(r.LongAnswer03) = '' and
            RTRIM(r.LongAnswer04) = '') Then t.units
          Else 0
        End
    End,
  EMP09_Hrs =
    Case
      When
        substring(t.project,1,3) = 'INT' and
        t.pjt_entity = 'EMP09' Then t.units
      Else 0
    End,
  Other_Client_Hrs =
    Case
      When 
        LTRIM(r.LongAnswer00) = '' Then
          Case
            When
              substring(t.project,1,3) = 'INT' Then 0
            Else t.units
          End
      Else
        Case
          When
            substring(t.project,1,3) = 'INT' or

            (substring(t.project,1,3) = RTRIM(r.LongAnswer00) and
            (substring(t.project,4,3) = RTRIM(r.LongAnswer01) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer02) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer03) or
            substring(t.project,4,3) = RTRIM(r.LongAnswer04))) or

            (substring(t.project,1,3) = RTRIM(r.LongAnswer00) and
            RTRIM(r.LongAnswer01) = '' and
            RTRIM(r.LongAnswer02) = '' and
            RTRIM(r.LongAnswer03) = '' and
            RTRIM(r.LongAnswer04) = '') Then 0
          Else t.units
        End
    End,
  Internal_Hrs = 
    Case
      When
        substring(t.project,1,3) = 'INT' and
        t.pjt_entity <> 'EMP09' Then t.units
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
  t.acct = 'DIRECT SALARY'

/*  and r.ri_id = '727'  */
GO
