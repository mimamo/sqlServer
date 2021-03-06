USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA938_Estimates]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_PA938_Estimates]

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
