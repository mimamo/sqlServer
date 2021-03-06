USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_PA934_JobEstimates]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA934_JobEstimates]

as

select r.project as 'Project',
sum(r.eac_amount) as 'EstimateAmountEAC',
sum(r.fac_amount) as 'EstimateAmountFAC',
sum(r.total_budget_amount) as 'EstimateAmountTotal'
from pjptdrol r
where
r.acct in ('ESTIMATE','ESTIMATE TAX')
group by r.project
GO
