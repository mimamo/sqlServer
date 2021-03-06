USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA939_FunctionEstimates]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA939_FunctionEstimates]

as

select s.project,
s.pjt_entity as 'FunctionCode',
sum(s.eac_amount) as 'EstimateAmountEAC',
sum(s.fac_amount) as 'EstimateAmountFAC',
sum(s.total_budget_amount) as 'EstimateAmountFunctionTotal'
from pjptdsum s
where s.acct in ('ESTIMATE','ESTIMATE TAX')
group by s.project, s.pjt_entity
GO
