USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ConsumedCmp_ItemCost]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ConsumedCmp_ItemCost]
	@BaseDecPl	Int,
	@BMIDecPl	Int,
	@DecPlPrcCst	Int,
	@DecPlQty	Int,
	@InvtIDParm	VARCHAR (30)
As
/*
	This procedure will remove from the ItemCost Comparison Table any records that have a
	quantity of zero.
*/
	Set	NoCount	On

	Delete	From 	IN10990_ItemCost
		Where	Round(Qty, @DecPlQty) = 0
			AND IN10990_ItemCost.InvtID LIKE @InvtIDParm
GO
