USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Check_InsuffQty]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10990_Check_InsuffQty]
	@DecPlQty	SmallInt,
	@InvtIDParm	VARCHAR (30)
As
	Select 	INTran.InvtID, INTran.TranAmt
		From	INTran Inner Join ItemSite (NoLock)
			On INTran.InvtID = ItemSite.InvtID
			And INTran.SiteID = ItemSite.SiteID
		Where	Round(ItemSite.QtyOnHand, @DecPlQty) >= 0
			And INTran.InSuffQty = 1
			And INTran.Qty = 0
			And INTran.Rlsed = 1
			And INTran.TranAmt <> 0
			And INTran.TranType = 'AJ'
			AND INTran.InvtID LIKE @InvtIDParm
GO
