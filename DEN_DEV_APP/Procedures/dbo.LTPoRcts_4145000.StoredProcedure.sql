USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LTPoRcts_4145000]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[LTPoRcts_4145000]
	@InvtID Varchar(30),
	@SiteID VarChar(10)
AS
Select
	POTran.PONbr,
	Max(POTran.RcptDate) As 'RcptDate',
	Max(PurchOrd.PODate) As 'PODate'
	From
	POTran,
	PurOrdDet,
	PurchOrd
Where
	POTran.InvtID = @InvtID
	And POTran.SiteID = @SiteID
	And POTran.POOriginal = 'Y' 		-- On the Original PO
	And POTran.JrnlType = 'PO'		-- From the PO Module
	And POTran.TranType = 'R'		-- For a receipt
	And POTran.PONbr = PurOrdDet.PONbr
	And PoTran.POLineRef = PurOrdDet.LineRef
	And PurOrdDet.OpenLine = 0		-- Line no longer Open
	And PurOrdDet.IRIncLeadTime = 1		-- And is set for Forecasting
	And POTran.PONbr = PurchOrd.PONbr
-- Group by is to ensure that get a single entry for the PO / Lineref combo
Group By
	POTran.InvtID,
	POTran.SiteID,
	POTran.PONbr,
	POTran.POLineRef
Order By
	POTran.InvtID,
	POTran.SiteID,
	RcptDate Desc,
	POTran.PONbr,
	POTran.POLineRef
GO
