USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmelc00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmelc00] 
as

select 
  e.ri_id,  
  e.emp_name,
  e.Dept_Name,
  e.emp_title,
  Client_Hrs = sum(e.Client_Hrs),
  EMP09_Hrs = sum(e.EMP09_Hrs),
  Other_Client_Hrs = sum(e.Other_Client_Hrs),
  Internal_Hrs = sum(e.Internal_Hrs)
  
from xmelc01 e

group by ri_id,emp_name,Dept_Name,emp_title
GO
