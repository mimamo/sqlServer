USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_PA005_PO]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA005_PO]

as
SELECT p.PONbr
, p.VendID
, p.VouchStage
, p.PODate
, p.Buyer
, p.user7 as 'DueDate'
, p.noteID as 'HeaderNoteID'

, d.ProjectID 
, d.TaskID
, d.QtyOrd
, d.User5 as 'ItemNum'
, d.LineRef
, d.TranDesc
, d.InvtID
, d.noteID as 'DetailNoteID'

, ISNULL(a.RefNbr, '') as 'RefNbr'
, ISNULL(a.LineNbr, '') as 'LineNbr'
, ISNULL(a.ExtRefNbr, '') as 'ExtRefNbr'
, ISNULL(a.POLineRef, '') as 'POLineRef'
, ISNULL(a.CuryTranAmt, 0) as 'CuryCostVouched'
, ISNULL(a.CuryUnitPrice, 0) as 'CuryUnitCost'
, ISNULL(a.Qty, 0) as 'QtyVouched'
FROM PurchOrd p JOIN PurOrdDet d ON p.PONbr = d.PONbr
	LEFT JOIN APTran a ON d.PONbr = a.PONbr 
		AND d.TaskID = a.TaskID
		AND d.LineRef = a.POLineRef
GO
