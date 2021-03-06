USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ResetValues_Location]    Script Date: 12/21/2015 13:44:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ResetValues_Location]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will update the Location comparison table by clearing any fields that
	are going to be recalculated during the validation process.
*/
	Set	NoCount On

	Update	IN10990_Location
		Set	QtyOnHand = 0
		Where	Changed = 1
			AND IN10990_Location.InvtID LIKE @InvtIDParm
GO
