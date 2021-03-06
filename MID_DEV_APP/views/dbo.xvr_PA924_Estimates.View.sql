USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA924_Estimates]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[xvr_PA924_Estimates]

as

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA924_Estimates.sql
*
*   Notes:  


	select *
	from MID_DEV_APP.dbo.xvr_PA924_Estimates
	where project in('00583814AGY', '00427814AGY', '00572314AGY', -- incorrect
					'00383813AGY','00515814AGY', '00492114AGY', '00517714AGY')	-- correct	
	order by project

	select Project = r.project,
		EstimateAmountEAC = r.eac_amount,
		EstimateAmountFAC = r.fac_amount,
		EstimateAmountTotal = r.total_budget_amount, *
	from MID_DEV_APP.dbo.pjptdrol r
	inner join MID_DEV_APP.dbo.pjacct a 
		on r.acct = a.acct
	where r.project in('00583814AGY', '00427814AGY', '00572314AGY', -- incorrect
					'00383813AGY','00515814AGY', '00492114AGY', '00517714AGY')	-- correct	
		and r.acct in ('ESTIMATE','ESTIMATE TAX')
	order by r.project

October2015


	select acct, count(1)
	from MID_DEV_APP.dbo.pjacct
	group by acct

	select top 100  *
	from MID_DEV_APP.dbo.pjacct
	--where acct = 'ESTIMATE'
	order by acct

*                  
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/

select Project = r.project,
	EstimateAmountEAC = sum(r.eac_amount),
	EstimateAmountFAC = sum(r.fac_amount),
	EstimateAmountTotal = sum(r.total_budget_amount)
from MID_DEV_APP.dbo.pjptdrol r
inner join MID_DEV_APP.dbo.pjacct a 
	on r.acct = a.acct
where r.acct in ('ESTIMATE','ESTIMATE TAX')
group by r.project


GO
