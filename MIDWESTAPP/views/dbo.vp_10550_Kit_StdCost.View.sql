USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vp_10550_Kit_StdCost]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	View [dbo].[vp_10550_Kit_StdCost]
As
	Select	Kit.KitID, ItemSite.SiteID,
		PDirStdCst =	Sum(Round(Component.StdQty *
					Case	When	CompSite.InvtID Is Null
							Then	CompInvt.StdCost
						Else	CompSite.StdCost
					End, DecPl.DecPlPrcCst)),
		BMIPDirStdCst =	Sum(Round(Component.StdQty *
					Case	When	CompSite.InvtID Is Null
							Then	CompInvt.BMIStdCost
						Else	CompSite.BMIStdCost
					End, DecPl.DecPLPrcCst))
		From	vp_DecPl DecPl (NoLock),
			Kit (NoLock) Inner Join Component (NoLock)
			On Kit.KitID = Component.KitID
			Inner Join Inventory CompInvt (NoLock)
			On CompInvt.InvtID = Component.CmpnentID
			Inner Join Inventory (NoLock)
			On Kit.KitID = Inventory.InvtID
			Inner Join ItemSite (NoLock)
			On Kit.KitID = ItemSite.InvtID
			Left Join ItemSite CompSite (NoLock)
			On CompSite.InvtID = Component.CmpnentID
			And CompSite.SiteID = ItemSite.SiteID
		Where	Inventory.ValMthd = 'T'	/* Standard Cost Valuation Method */
			And Kit.KitType <> 'B' /* Bill of Material */
		Group By Kit.KitID, ItemSite.SiteID
GO
