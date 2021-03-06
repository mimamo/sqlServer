USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmelb00_Main]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmelb00_Main] 
as
select 
  t.ri_id,
  EmployeeID           = t.employee,
  Employee_Name        = t.emp_name,
  Client_ID            = t.custid,
  Client_Name          = t.custname,
  Product              = t.Product,
  Client_Product       = t.Client_Product,
  Total_Period_Std_Hrs = Max(t.Total_Period_Std_Hrs),
  Jan_Hrs              = Sum(t.Jan_Hrs),
  Emp_Jan_Std_Hrs      = Max(t.Emp_Jan_Std_Hrs),
  Feb_Hrs              = Sum(t.Feb_Hrs),
  Emp_Feb_Std_Hrs      = Max(t.Emp_Feb_Std_Hrs),
  Mar_Hrs              = Sum(t.Mar_Hrs),
  Emp_Mar_Std_Hrs      = Max(t.Emp_Mar_Std_Hrs),
  Apr_Hrs              = Sum(t.Apr_Hrs),
  Emp_Apr_Std_Hrs      = Max(t.Emp_Apr_Std_Hrs),
  May_Hrs              = Sum(t.May_Hrs),
  Emp_May_Std_Hrs      = Max(t.Emp_May_Std_Hrs),
  Jun_Hrs              = Sum(t.Jun_Hrs),
  Emp_Jun_Std_Hrs      = Max(t.Emp_Jun_Std_Hrs),
  Jul_Hrs              = Sum(t.Jul_Hrs),
  Emp_Jul_Std_Hrs      = Max(t.Emp_Jul_Std_Hrs),
  Aug_Hrs              = Sum(t.Aug_Hrs),
  Emp_Aug_Std_Hrs      = Max(t.Emp_Aug_Std_Hrs),
  Sep_Hrs              = Sum(t.Sep_Hrs),
  Emp_Sep_Std_Hrs      = Max(t.Emp_Sep_Std_Hrs),
  Oct_Hrs              = Sum(t.Oct_Hrs),
  Emp_Oct_Std_Hrs      = Max(t.Emp_Oct_Std_Hrs),
  Nov_Hrs              = Sum(t.Nov_Hrs),
  Emp_Nov_Std_Hrs      = Max(t.Emp_Nov_Std_Hrs),
  Dec_Hrs              = Sum(t.Dec_Hrs),
  Emp_Dec_Std_Hrs      = Max(t.Emp_Dec_Std_Hrs)
from rptruntime r
  join xmelb00_Detail t
  on r.ri_id = t.ri_id
-- where r.ri_id = '181'

group by t.ri_id, t.employee, t.emp_name, t.custid, t.custname, t.Product, t.Client_Product

-- order by t.emp_name,t.custid
GO
