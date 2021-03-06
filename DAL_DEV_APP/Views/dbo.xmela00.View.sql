USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[xmela00]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmela00] 
as

select 
  e.ri_id,  
  e.emp_name,
  e.employee,
  e.Dept_Name,
  e.emp_title,
  Client_Hrs = sum(e.Client_Hrs),
  Internal_Hrs = sum(e.Internal_Hrs)
  
from xmela02 e

group by ri_id, emp_name, employee, Dept_Name, emp_title
GO
