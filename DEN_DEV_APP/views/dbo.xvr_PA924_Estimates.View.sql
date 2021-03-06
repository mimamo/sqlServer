USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA924_Estimates]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_PA924_Estimates]

as

select Project =  r.project,
	EstimateAmountEAC = sum(r.eac_amount),
	EstimateAmountFAC = sum(r.fac_amount),
	EstimateAmountTotal = sum(r.total_budget_amount)
from DEN_DEV_APP.dbo.pjptdrol r
inner join DEN_DEV_APP.dbo.pjacct a 
	on r.acct = a.acct
where r.acct in ('ESTIMATE','ESTIMATE TAX')
group by r.project


GO
