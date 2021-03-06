USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ResetValues_ItemSite]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ResetValues_ItemSite]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will update the ItemSite comparison table by clearing any fields that
	are going to be recalculated during the validation process.
*/
	Set	NoCount On

	Update	IN10990_ItemSite
		Set	AvgCost = 0,
			BMIAvgCost = 0,
			BMITotCost = 0,
			QtyOnHand = 0,
			TotCost = 0
		Where	Changed = 1
			AND InvtID LIKE @InvtIDParm
GO
