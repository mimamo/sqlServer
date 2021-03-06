USE [MID_DEV_APP]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[xvr_PA924_Main]

AS

/*******************************************************************************************************
*	MID_DEV_APP.dbo.xvr_PA924_Main.sql
*
*   Notes:  


	select *
	from MID_DEV_APP.dbo.xvr_PA924_Main
	where project in('00583814AGY', -- incorrect
					'00383813AGY')	-- correct

*                  
*   Modifications:   
*   Name				Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/


SELECT CustomerCode = p.pm_id01,
	CustomerName = isnull(c.[name],'Customer Name Unavailable'),
	ProductCode = p.pm_id02,
	ProductDesc = isnull(bcyc.code_value_desc,''),
	Project = p.project,
	JobCat = p.contract_type,
	ExtCost = po.ExtCost,
	CostVouched = po.CostVouched,
	ProjectDesc = p.project_desc,
	PONumber = p.purchase_order_num,
	StatusPA = p.status_pa,
	StartDate = p.[start_date],
	OnShelfDate = p.end_date, 
	CloseDate = p.pm_id08,
	[Type] = p.pm_id04,
	SubType = p.pm_id05,
	ECD = x.pm_id28,
	OfferNum = p.pm_id32,
	ClientContact = xc.CName,
	ContactEmailAddress = xc.EmailAddress,
	RetailCustName = xr.RCustName,
	RetailCustomerID = p.user1,
	Differentiator = p.user3,
	PTODesignator = p.user4,
	PM = p.manager1,
	AcctService = p.manager2,
	FJ_Estimate = isnull(x.pm_id26,0),
	EstimateAmountEAC = isnull(est.EstimateAmountEAC,0),
	EstimateAmountFAC = isnull(est.EstimateAmountFAC,0),
	EstimateAmountTotal = isnull(est.EstimateAmountTotal,0),
	ActAcct = isnull(act.Acct,''),
	Amount01 = isnull(act.Amount01,0),
	Amount02 = isnull(act.Amount02,0),
	Amount03 = isnull(act.Amount03,0),
	Amount04 = isnull(act.Amount04,0),
	Amount05 = isnull(act.Amount05,0),
	Amount06 = isnull(act.Amount06,0),
	Amount07 = isnull(act.Amount07,0),
	Amount08 = isnull(act.Amount08,0),
	Amount09 = isnull(act.Amount09,0),
	Amount10 = isnull(act.Amount10,0),
	Amount11 = isnull(act.Amount11,0),
	Amount12 = isnull(act.Amount12,0),
	Amount13 = isnull(act.Amount13,0),
	Amount14 = isnull(act.Amount14,0),
	Amount15 = isnull(act.Amount15,0),
	AmountBF = isnull(act.AmountBF,0),
	FSYearNum = isnull(act.FSYearNum,'1900'),
	AcctGroupCode = isnull(act.AcctGroupCode,''),
	ControlCode = isnull(act.ControlCode,'')
FROM MID_DEV_APP.dbo.PJPROJ p 
LEFT JOIN MID_DEV_APP.dbo.Customer c 
	on p.pm_id01 = c.custid
LEFT JOIN MID_DEV_APP.dbo.PJCODE bcyc 
	on p.pm_id02 = bcyc.code_value 
	and bcyc.code_type = 'BCYC'
LEFT JOIN MID_DEV_APP.dbo.xvr_PA924_Estimates est 
	on p.project = est.project
LEFT JOIN MID_DEV_APP.dbo.xvr_PA924_Actuals act 
	on p.project = act.project
LEFT JOIN MID_DEV_APP.dbo.xvr_PA924_PO po 
	on p.project = po.ProjectID
LEFT JOIN MID_DEV_APP.dbo.PJPROJEX x 
	ON p.project = x.project
LEFT JOIN MID_DEV_APP.dbo.xClientContact xc 
	ON p.user2 = xc.EA_ID
LEFT JOIN MID_DEV_APP.dbo.xRetailCustomer xr 
	ON p.user1 = xr.RCustID

GO
