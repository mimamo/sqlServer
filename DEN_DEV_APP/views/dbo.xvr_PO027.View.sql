USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PO027]    Script Date: 12/21/2015 14:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PO027]

AS

SELECT PurOrdDet.PONbr as 'PurOrdDetPONbr'
, PurchOrd.PODate as 'PurOrdDetPODate'
, PurOrdDet.InvtID as 'PurOrdDetInvtID'
, PurOrdDet.User5 as 'PurOrdDetItemNum'
, PurOrdDet.ProjectID as 'PurOrdDetProjectID'
, PurOrdDet.TaskID as 'PurOrdDetFunction'
, PurOrdDet.QtyOrd as 'PurOrdDetQtyOrd'
, PurOrdDet.PurchUnit as 'PurOrdDetPurchUnit'
, PurOrdDet.CuryUnitCost as 'PurOrdDetCuryUnitCost'
, PurchOrd.Status as 'PurchOrdStatus'
, PurchOrd.VendName as 'PurchOrdVendName'
, PurOrdDet.CuryExtCost as 'PurOrdDetExtCost'
, PurOrdDet.NoteID as 'PurOrdDetNoteID'
, ISNULL(snote.sNoteText, '') as 'PurOrdDetNotes'
FROM PurchOrd JOIN PurOrdDet ON PurchOrd.PONbr = PurOrdDet.PONbr
	LEFT JOIN snote ON  PurOrdDet.NoteID = snote.nID
GO
