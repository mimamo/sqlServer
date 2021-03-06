USE [DALLASAPP]
GO
/****** Object:  View [dbo].[XQELC00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[XQELC00] 
as 
select pjemppjt.*, emp_name, date_terminated, code_value_desc labor_class_desc 
from pjemppjt 
inner join XQELC00_Base on pjemppjt.employee = XQELC00_Base.employee 
and pjemppjt.effect_date = XQELC00_Base.effect_date 
inner join pjemploy 
on pjemppjt.employee = pjemploy.employee 
and emp_status = 'A' 
left outer join xqLaborClasses 
on labor_class_cd = code_value
GO
