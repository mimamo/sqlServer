USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Kit_PV]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[StdCost_Kit_PV]
	@SiteID	VarChar(10),
	@KitID	VarChar(30)
As
	Select	Kit.KitID, ItemSite.SiteID, Kit.Descr
		From 	Kit (NoLock) Inner Join Inventory (NoLock)
			On Kit.KitID = Inventory.InvtID
			Inner Join ItemSite (NoLock)
			On Inventory.InvtID = ItemSite.InvtID
		Where	Inventory.ValMthd = 'T' /* Standard Cost Valuation Method */
			And Kit.KitType <> 'B' /* Bill of Material */
			And ItemSite.SiteID Like @SiteID
			And Kit.KitID Like @KitID
	   	Order By Kit.KitId
GO
