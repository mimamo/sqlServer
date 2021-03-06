USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PO022]    Script Date: 12/21/2015 14:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PO022]

AS

SELECT x.ProjectDisposition
, po.CuryPOAmt as 'PurchOrdCuryPOAmt'
, po.Buyer as 'PurchOrdBuyer'
, d.CuryExtCost as 'PurOrdDetCuryExtCost'
, po.Status as 'PurchOrdStatus'
, po.VendName as 'PurchOrdVendName'
, d.PurchUnit as 'PurOrdDetPurchUnit'
, d.QtyOrd as 'PurOrdDetQtyOrd'
, d.QtyVouched as 'PurOrdDetQtyVouched'
, d.CuryUnitCost as 'PurOrdDetCuryUnitCost'
, d.CuryCostVouched as 'PurOrdDetCuryCostVouched'
, d.RcptPctMax as 'PurOrdDetRcptPctMax'
, d.ReqdDate as 'PurOrdDetReqDate'
, d.PromDate as 'PurOrdDetPromDate'
, d.User5 as 'PurOrdDetItemNum'
, po.PODate as 'PurOrdDetPODate'
, po.PONbr as 'PurchOrdPONbr'
, d.PONbr as 'PurOrdDetPONbr'
, ISNULL(a.PONbr, '') as 'APTranPONbr'
, ISNULL(ad.PONbr, '') as 'APDocPONbr'
, d.VouchStage as 'PurOrdDetVouchStage'
, d.ProjectID as 'PurOrdDetProjectID'
, d.TaskID as 'PurOrdDetFunction'
, d.InvtID as 'PurOrdDetInvtID'
, po.VendID as 'PurchOrdVendID'
, d.LineRef as 'PurOrdDetLineRef'
, CAST(d.LineRef as int) as 'LineRefNbr'
, ISNULL(a.POLineRef, '') as 'APTranPOLineRef'
, ISNULL(a.VendId, '') as 'APTranVendID'
, ISNULL(a.InvtID, '') as 'APTranInvtID'
, ISNULL(a.TaskID, '') as 'APTranFunction'
, ISNULL(a.ProjectID, '') as 'APTranProjectID'
, ISNULL(SUM(a.Qty), 0) as 'APTranQty'
, ISNULL(a.User5, '') as 'APTranItemNum'
, ISNULL(SUM(a.CuryUnitPrice),0) as 'APTranCuryUnitPrice'
, ISNULL(SUM(a.CuryTranAmt),0) as 'APTranCuryTranAmt'
, ISNULL(a.TranDesc, '') as 'APTranTranDesc'
, ISNULL(ad.DocDate, '1900/01/01') as 'APDocDocDate'
, ISNULL(a.RefNbr, '') as 'APTranRefNbr'
, ISNULL(ad.RefNbr, '') as 'APDocRefNbr'
, ISNULL(ad.InvcNbr, '') as 'ClientRefNum'
, p.Manager1 as 'PM_ID'
, REPLACE(e.emp_name, '~', ', ') as 'PMName'
FROM PurchOrd po JOIN PurOrdDet d ON po.PONbr = d.PONbr 
	LEFT JOIN APTran a ON d.PONbr = a.PONbr 
		AND d.TaskID = a.TaskID
		AND d.LineRef = a.POLineRef
	LEFT JOIN APDoc ad ON a.PONbr = ad.PONbr
		AND a.RefNbr = ad.RefNbr
	LEFT JOIN PJPROJ p ON d.ProjectID = p.Project
	LEFT JOIN PJEMPLOY e ON p.Manager1 = e.employee
	LEFT JOIN xvr_PO022_PJBILL x ON d.ProjectID = x.project
GROUP BY d.ProjectID, po.CuryPOAmt, d.LineRef, d.PONbr, po.Buyer
, d.CuryExtCost, po.Status, po.VendName, d.PurchUnit, d.QtyOrd, d.QtyVouched
, d.CuryUnitCost, d.TaskID, d.CuryCostVouched, d.RcptPctMax, d.ReqdDate, d.PromDate, d.VouchStage, d.User5
, po.PODate, a.Qty, a.User5, a.CuryUnitPrice, a.CuryTranAmt, a.TranDesc, a.ProjectID
, a.VendId, ad.DocDate, po.VendID, ad.RefNbr, a.RefNbr, a.TaskID, po.VendID, a.PONbr
, ad.PONbr, po.PONbr, d.InvtID, a.InvtID, a.POLineRef, p.Manager1, e.emp_name, x.ProjectDisposition, ad.InvcNbr
GO
