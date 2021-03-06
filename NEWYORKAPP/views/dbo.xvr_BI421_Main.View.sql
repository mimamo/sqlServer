USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_BI421_Main]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[xvr_BI421_Main]
as
SELECT DISTINCT GLTran.Module as 'GLTranModule'
, GLTran.ProjectID as 'GLTranProjectID'
, GLTran.BatNbr as 'GLTranBatNbr'
, GLTran.RefNbr as 'GLTranRefNbr'
, PJINVHDR.invoice_date as 'Invoice_Date'
, PJINVHDR.gross_amt as 'InvoiceAmount'
, PJINVHDR.invoice_num as 'InvoiceNum'
, PJPROJ.pm_id01 as 'CustCode'
, Customer.[Name] as 'CustName'
, PJPROJ.project_desc as 'ProjectDesc'
, PJPROJ.pm_id02 as 'ProductCode'
, PJPROJ.purchase_order_num as 'ClientRefNum'
, pjcode.code_value_desc as 'Product'
, isnull(est.EstimateAmountTotal, 0) as 'EstimateAmountTotal'
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
 FROM  GLTran LEFT OUTER JOIN PJINVHDR ON GLTran.BatNbr = PJINVHDR.batch_id AND GLTran.RefNbr = PJINVHDR.invoice_num 
	LEFT OUTER JOIN PJINVDET ON PJINVHDR.draft_num = PJINVDET.draft_num 
	LEFT OUTER JOIN PJPROJ ON PJINVDET.project = PJPROJ.project 
	LEFT OUTER JOIN PJCODE ON PJPROJ.pm_id02 = PJCODE.code_value 
	LEFT OUTER JOIN Customer ON PJPROJ.pm_id01 = Customer.CustId 
	LEFT OUTER JOIN xvr_BI421_Estimates est ON GLTran.ProjectID = est.Project
	LEFT OUTER JOIN xvr_BI421_Actuals act ON GLTran.ProjectID = act.Project
 WHERE  GLTran.Module = 'BI' 
	AND GLTran.JrnlType <> 'REV' 
	AND PJCODE.code_type = 'BCYC'
GO
