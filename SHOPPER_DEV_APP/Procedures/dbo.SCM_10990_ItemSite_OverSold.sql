USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_ItemSite_OverSold]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_ItemSite_OverSold]
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt
As
	Select	ItemSite.InvtID, ItemSite.SiteID,
		Inventory.ValMthd, QtyUnCosted = Cast(0 As Float), QtyOnHand = Cast(0 As Float)
		From	ItemSite (NoLock) Inner Join Inventory (NoLock)
			On ItemSite.InvtID = Inventory.InvtID
		Where	Round(ItemSite.QtyOnHand, @DecPlQty) < 0
			And Inventory.ValMthd In ('A', 'F', 'L')
		Order By ItemSite.InvtID, ItemSite.SiteID
GO
