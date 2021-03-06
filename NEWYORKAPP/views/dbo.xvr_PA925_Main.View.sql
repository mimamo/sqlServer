USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_PA925_Main]    Script Date: 12/21/2015 16:00:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA925_Main]

AS

SELECT p.pm_id01 as 'CustomerCode'
, isnull(c.[name],'Customer Name Unavailable') as 'CustomerName'
, p.pm_id02 as 'ProductCode'
, isnull(bcyc.code_value_desc,'') as 'ProductDesc'
, p.project as 'Project'
, p.contract_type as 'JobCat'
, po.ExtCost as 'ExtCost'
, po.CostVouched as 'CostVouched'
, p.project_desc as 'ProjectDesc'
, p.purchase_order_num as 'PONumber'
, p.status_pa as 'StatusPA'
, p.start_date as 'StartDate'
, p.end_date AS 'OnShelfDate'
, p.pm_id08 AS 'CloseDate'
, p.pm_id04 AS 'Type'
, p.pm_id05 AS 'SubType'
, x.pm_id28 AS 'ECD'
, p.pm_id32 AS 'OfferNum'
, xc.CName as 'ClientContact'
, xc.EmailAddress as 'ContactEmailAddress'
, p.user3 as 'Differentiator'
, p.user4 as 'PTODesignator'
, p.manager1 as 'PM'
, p.manager2 as 'AcctService'
, isnull(x.pm_id26,0) as 'FJ_Estimate'
, isnull(est.EstimateAmountEAC,0) as 'EstimateAmountEAC'
, isnull(est.EstimateAmountFAC,0) as 'EstimateAmountFAC'
, isnull(est.EstimateAmountTotal,0) as 'EstimateAmountTotal'
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
, ISNULL(e.ULEAmount, 0) as 'ULEAmount'
, ISNULL(h.Create_Date, '01/01/1900') as 'ULECreate_Date'
-- xIGProdReporting fields
, ProdRpt.Brand as 'RptBrand'
, ProdRpt.ClientIdentifier as 'RptClientIdentifier'
, ProdRpt.Director as 'RptDirector'
, ProdRpt.GAD as 'RptGAD'
, ProdRpt.HrsTab as 'RptHrsTab'
, ProdRpt.OOS as 'RptOOS'
, ProdRpt.Region as 'RptRegion'
, ProdRpt.Retailer as 'RptRetailer'
, ProdRpt.RptClient as 'RptRptClient'
, ProdRpt.SVP as 'RptSVP'
, ProdRpt.SubBrand as 'RptSubBrand'
, ProdRpt.VP as 'RptVP'
, ProdRpt.WIPGroup as 'RptWIPGroup'
, ProdRpt.channel as 'RptChannel'

FROM PJPROJ p LEFT JOIN Customer c on p.pm_id01 = c.custid
	LEFT JOIN PJCODE bcyc on p.pm_id02 = bcyc.code_value and bcyc.code_type = 'BCYC'
	LEFT JOIN xvr_PA925_Estimates est on p.project = est.project
	LEFT JOIN xvr_PA925_Actuals act on p.project = act.project
	LEFT JOIN xvr_PA925_PO po on p.project = po.ProjectID
	LEFT JOIN PJPROJEX x ON p.project = x.project
	LEFT JOIN xClientContact xc ON p.user2 = xc.EA_ID
	LEFT JOIN xvr_Est_ULE_Project e ON p.project = e.Project
	LEFT JOIN PJREVHDR h ON e.Project = h.Project AND e.RevId = h.RevId
	LEFT JOIN xIGProdReporting ProdRpt ON p.pm_id02 = ProdRpt.ProdID
GO
