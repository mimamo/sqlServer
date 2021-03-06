USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_BI904_Estimates]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI904_Estimates]

AS

SELECT r.project as 'Project'
, sum(r.eac_amount) as 'EstimateAmountEAC'
, sum(r.fac_amount) as 'EstimateAmountFAC'
, sum(r.total_budget_amount) as 'EstimateAmountTotal'
FROM pjptdrol r JOIN pjacct a on r.acct = a.acct
WHERE r.acct in ('ESTIMATE','ESTIMATE TAX')
GROUP BY r.project
GO
