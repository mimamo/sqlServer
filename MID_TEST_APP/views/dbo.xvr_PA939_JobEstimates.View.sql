USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA939_JobEstimates]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA939_JobEstimates]

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
