USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA927_Estimates]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA927_Estimates]

as

select 
r.project as 'Project',
sum(r.eac_amount) as 'EstimateAmountEAC',
sum(r.fac_amount) as 'EstimateAmountFAC',
sum(r.total_budget_amount) as 'EstimateAmountTotal'
from pjptdrol r
join pjacct a on r.acct=a.acct
where
r.acct in ('ESTIMATE','ESTIMATE TAX')
group by r.project
GO
