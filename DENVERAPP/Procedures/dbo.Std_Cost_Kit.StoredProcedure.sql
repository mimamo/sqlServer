USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Std_Cost_Kit]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[Std_Cost_Kit]
	@CpnyID	VarChar(10),
	@SiteID	VarChar(10),
	@KitID	VarChar(30)
As
	Select	Kit.*, ItemSite.SiteID
		From	Kit (NoLock) Inner Join Inventory (NoLock)
			On Kit.KitID = Inventory.InvtID
			Inner Join ItemSite (NoLock)
			On Inventory.InvtID = ItemSite.InvtID
		Where	Kit.KitType <> 'B' /* Bill of Material */
			And Inventory.ValMthd = 'T'	/* Standard Cost */
			And ItemSite.CpnyID = @CpnyID
			And Kit.KitID Like @KitID
			And ItemSite.SiteID Like @SiteID
		Order By Kit.KitID
GO
