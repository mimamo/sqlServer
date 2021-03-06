USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[XWrk_BI902_1]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[XWrk_BI902_1]
AS
SELECT     RI_ID, pm_id01, code_ID, project_billwith, project, acct, round(sum(amount),2) as Amount
FROM         dbo.xwrk_VBI902
WHERE     (acct IN ('prebill')) 
group by RI_ID, pm_id01, code_ID, project_billwith, project, acct
GO
