USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmluc_Emp_Title]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmluc_Emp_Title]
as
select
  p.employee,
  l.code_value_desc emp_title
from pjemppjt p
inner join xmluc_EmpPjt_MaxDate e
 on p.employee = e.employee
 and p.effect_date = e.effect_date
left outer join xmlabc00 l
 on p.labor_class_cd = l.code_value
GO
