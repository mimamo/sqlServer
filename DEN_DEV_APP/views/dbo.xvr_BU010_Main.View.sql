USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BU010_Main]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU010_Main]

AS

SELECT p.project as 'Project'

, isnull(po.ExtCost, 0) as 'ExtCost'
, isnull(po.CostVouched, 0) as 'CostVouched'
, isnull(act.Acct,'') as 'ActAcct'
, isnull(act.Amount01,0) as 'Amount01'
, isnull(act.Amount02,0) as 'Amount02'
, isnull(act.Amount03,0) as 'Amount03'
, isnull(act.Amount04,0) as 'Amount04'
, isnull(act.Amount05,0) as 'Amount05'
, isnull(act.Amount06,0) as 'Amount06'
, isnull(act.Amount07,0) as 'Amount07'
, isnull(act.Amount08,0) as 'Amount08'
, isnull(act.Amount09,0) as 'Amount09'
, isnull(act.Amount10,0) as 'Amount10'
, isnull(act.Amount11,0) as 'Amount11'
, isnull(act.Amount12,0) as 'Amount12'
, isnull(act.Amount13,0) as 'Amount13'
, isnull(act.Amount14,0) as 'Amount14'
, isnull(act.Amount15,0) as 'Amount15'
, isnull(act.AmountBF,0) as 'AmountBF'
, isnull(act.FSYearNum,'1900') as 'FSYearNum'
, isnull(act.AcctGroupCode,'') as 'AcctGroupCode'
, isnull(act.ControlCode,'') as 'ControlCode'
FROM PJPROJ p LEFT JOIN xvr_BU010_Actuals act on p.project = act.project
	LEFT JOIN xvr_BU010_PO po on p.project = po.ProjectID
GO
