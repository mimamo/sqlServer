USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Consumed_ItemCost]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Consumed_ItemCost]
	@BaseDecPl	Int,
	@BMIDecPl	Int,
	@DecPlPrcCst	Int,
	@DecPlQty	Int,
	@InvtIDParm	VARCHAR (30)
As
/*
	This procedure will remove from the ItemCost Table any records that have a
	quantity of zero.
*/
	Set	NoCount	On

	Delete	From 	ItemCost
		Where	Round(Qty, @DecPlQty) = 0
			AND InvtID LIKE @InvtIDParm
GO
