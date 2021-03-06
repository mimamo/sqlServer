USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ResetValues_ItemCost]    Script Date: 12/21/2015 16:07:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ResetValues_ItemCost]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will update the ItemCost comparison table by clearing any fields that
	are going to be recalculated during the validation process.
*/
	Set	NoCount On

	Update	IN10990_ItemCost
		Set	BMITotCost = 0,
			Qty = 0,
			TotCost = 0,
			UnitCost = 0
		Where	Changed = 1
			AND IN10990_ItemCost.InvtID LIKE @InvtIDParm
GO
