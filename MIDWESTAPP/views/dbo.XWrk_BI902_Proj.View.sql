USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[XWrk_BI902_Proj]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XWrk_BI902_Proj] as
select 
RI_ID, pm_id01, code_ID, project_billwith, project, acct, sum(amount) as Amount
from XWrk_BI902_1
group by RI_ID,pm_id01, code_ID,project_billwith, project, acct
GO
