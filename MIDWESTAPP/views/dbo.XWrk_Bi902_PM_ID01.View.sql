USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[XWrk_Bi902_PM_ID01]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XWrk_Bi902_PM_ID01] as
select RI_ID, pm_id01, round(Sum(amount),2) as Amount
from XWrk_BI902_PROJ
group by RI_ID, PM_Id01
GO
