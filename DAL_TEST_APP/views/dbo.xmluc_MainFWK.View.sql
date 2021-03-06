USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmluc_MainFWK]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmluc_MainFWK] 
as
select 
  f.ri_id,
  t.project,
  t.units,
  t.employee,
  t.trans_date,
  t.fiscalno,
  t.gl_subacct Dept,
  s.descr Dept_Name,
  e.emp_name,
  m.emp_title,
  e.date_hired,
  e.date_terminated,
  custid = 'FWK',
  c.custname,

  Jan_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '01' Then t.units
      Else 0 
    End,
  Emp_Jan_Std_Hrs =
    Case
      When e.date_hired <= f.Jan_End_Date Then
        Case
          When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jan_Start_Date)
            and t.fiscalno <= begpernbr Then f.Jan_Std_Hrs
          Else 0
        End
      Else 0
    End,
 
  Feb_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '02' Then t.units
      Else 0 
    End,
  Emp_Feb_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '02' Then
        Case
          When e.date_hired <= f.Feb_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Feb_Start_Date)
                and t.fiscalno <= begpernbr Then f.Feb_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,
 
  Mar_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '03' Then t.units
      Else 0
    End,
  Emp_Mar_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '03' Then
        Case
          When e.date_hired <= f.Mar_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Mar_Start_Date)
                and t.fiscalno <= begpernbr Then f.Mar_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,
 
  Apr_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '04' Then t.units
      Else 0
    End,
  Emp_Apr_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '04' Then
        Case
          When e.date_hired <= f.Apr_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Apr_Start_Date)
                and t.fiscalno <= begpernbr Then f.Apr_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  May_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '05' Then t.units
      Else 0
    End,
  Emp_May_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '05' Then
        Case
          When e.date_hired <= f.May_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.May_Start_Date)
                and t.fiscalno <= begpernbr Then f.May_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Jun_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '06' Then t.units
      Else 0
    End,
  Emp_Jun_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '06' Then
        Case
          When e.date_hired <= f.Jun_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jun_Start_Date)
                and t.fiscalno <= begpernbr Then f.Jun_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

Jul_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '07' Then t.units
      Else 0
    End,
  Emp_Jul_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '07' Then
        Case
          When e.date_hired <= f.Jul_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jul_Start_Date)
                and t.fiscalno <= begpernbr Then f.Jul_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Aug_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '08' Then t.units
      Else 0
    End,
  Emp_Aug_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '08' Then
        Case
          When e.date_hired <= f.Aug_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Aug_Start_Date)
                and t.fiscalno <= begpernbr Then f.Aug_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Sep_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '09' Then t.units
      Else 0
    End,
  Emp_Sep_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '09' Then
        Case
          When e.date_hired <= f.Sep_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Sep_Start_Date)
                and t.fiscalno <= begpernbr Then f.Sep_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Oct_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '10' Then t.units
      Else 0
    End,
  Emp_Oct_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '10' Then
        Case
          When e.date_hired <= f.Oct_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Oct_Start_Date)
                and t.fiscalno <= begpernbr Then f.Oct_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Nov_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '11' Then t.units
      Else 0
    End,
  Emp_Nov_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '11' Then
        Case
          When e.date_hired <= f.Nov_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Nov_Start_Date)
                and t.fiscalno <= begpernbr Then f.Nov_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End,

  Dec_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '12' Then t.units
      Else 0
    End,
  Emp_Dec_Std_Hrs =
    Case
      When substring(begpernbr,5,2) >= '12' Then
        Case
          When e.date_hired <= f.Dec_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Dec_Start_Date)
                and t.fiscalno <= begpernbr Then f.Dec_Std_Hrs
              Else 0
            End
          Else 0
        End
      Else 0
    End
  
from rptruntime r
  cross join pjtran t
  left outer join pjemploy e
  on t.employee = e.employee
  left outer join xmluc_Emp_Title m
  on t.employee = m.employee
  join xmluc_pjfiscal_Sum f
    on left(t.fiscalno,4) = f.Fiscal_Year
  left outer join xvr_ProjCustomers c
  on t.project = c.project
  left outer join SubAcct s
  on t.gl_subacct = s.sub

where f.ri_id = r.ri_id and
  t.fiscalno <= r.begpernbr and 
  left(t.fiscalno,4) = left(r.begpernbr,4) and
  t.acct = 'DIRECT SALARY' and
  substring(t.project,1,3) in ('FWK','SLU') and
  substring(t.project,4,3) not like 'GEN' and
  substring(t.project,4,3) not like 'NBZ' and
  substring(t.project,4,3) not like 'SEA'

/*  and r.ri_id = '232'  */
GO
