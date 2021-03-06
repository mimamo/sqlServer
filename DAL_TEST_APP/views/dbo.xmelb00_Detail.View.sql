USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmelb00_Detail]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmelb00_Detail] 
as
select 
  f.ri_id,
  t.employee,
  e.emp_name,
  c.custid,
  c.custname,
  Product = substring(t.project,4,3),
  Client_Product = substring(c.custid,1,3) + substring(t.project,4,3),
  Total_Period_Std_Hrs = f.Jan_Std_Hrs + f.Feb_Std_Hrs + f.Mar_Std_Hrs + f.Apr_Std_Hrs + f.May_Std_Hrs + f.Jun_Std_Hrs +
                         f.Jul_Std_Hrs + f.Aug_Std_Hrs + f.Sep_Std_Hrs + f.Oct_Std_Hrs + f.Nov_Std_Hrs + f.Dec_Std_Hrs,
  Jan_Hrs =
    Case
      When substring(t.fiscalno,5,2) = '01' Then t.units
      Else 0 
    End,
  Emp_Jan_Std_Hrs =
    Case
      When substring(begpernbr,5,2) = '01' Then
        Case
          When e.date_hired <= f.Jan_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jan_Start_Date) Then f.Jan_Std_Hrs
              Else 0
            End
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
      When substring(begpernbr,5,2) <= '02' and substring(endpernbr,5,2) >= '02' Then
        Case
          When e.date_hired <= f.Feb_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Feb_Start_Date) Then f.Feb_Std_Hrs
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
      When substring(begpernbr,5,2) <= '03' and substring(endpernbr,5,2) >= '03' Then
        Case
          When e.date_hired <= f.Mar_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Mar_Start_Date) Then f.Mar_Std_Hrs
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
      When substring(begpernbr,5,2) <= '04' and substring(endpernbr,5,2) >= '04' Then
        Case
          When e.date_hired <= f.Apr_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Apr_Start_Date) Then f.Apr_Std_Hrs
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
      When substring(begpernbr,5,2) <= '05' and substring(endpernbr,5,2) >= '05' Then
        Case
          When e.date_hired <= f.May_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.May_Start_Date) Then f.May_Std_Hrs
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
      When substring(begpernbr,5,2) <= '06' and substring(endpernbr,5,2) >= '06' Then
        Case
          When e.date_hired <= f.Jun_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jun_Start_Date) Then f.Jun_Std_Hrs
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
      When substring(begpernbr,5,2) <= '07' and substring(endpernbr,5,2) >= '07' Then
        Case
          When e.date_hired <= f.Jul_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Jul_Start_Date) Then f.Jul_Std_Hrs
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
      When substring(begpernbr,5,2) <= '08' and substring(endpernbr,5,2) >= '08' Then
        Case
          When e.date_hired <= f.Aug_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Aug_Start_Date) Then f.Aug_Std_Hrs
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
      When substring(begpernbr,5,2) <= '09' and substring(endpernbr,5,2) >= '09' Then
        Case
          When e.date_hired <= f.Sep_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Sep_Start_Date) Then f.Sep_Std_Hrs
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
      When substring(begpernbr,5,2) <= '10' and substring(endpernbr,5,2) >= '10' Then
        Case
          When e.date_hired <= f.Oct_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Oct_Start_Date) Then f.Oct_Std_Hrs
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
      When substring(begpernbr,5,2) <= '11' and substring(endpernbr,5,2) >= '11' Then
        Case
          When e.date_hired <= f.Nov_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Nov_Start_Date) Then f.Nov_Std_Hrs
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
      When substring(begpernbr,5,2) <= '12' and substring(endpernbr,5,2) >= '12' Then
        Case
          When e.date_hired <= f.Dec_End_Date Then
            Case
              When (e.date_terminated = '1900-01-01' or e.date_terminated >= f.Dec_Start_Date) Then f.Dec_Std_Hrs
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
  join xmelb00_pjfiscal_Sum f
    on left(t.fiscalno,4) = f.Fiscal_Year
       and f.ri_id = r.ri_id
  left outer join xvr_ProjCustomers c
  on t.project = c.project

where f.ri_id = r.ri_id and
  t.fiscalno >= r.begpernbr and 
  t.fiscalno <= r.endpernbr and
  t.acct = 'DIRECT SALARY'
--  and r.ri_id = '181'
GO
