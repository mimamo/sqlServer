USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_IRCalcPolicy_InvtID_SiteID]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_IRCalcPolicy_InvtID_SiteID]
	@InvtID	VarChar(30),
	@SiteID	VarChar(10)
As
	Select	IRCalcPolicy =	Case	When	Inventory.IRCalcPolicy = '2'
						Then Inventory.IRCalcPolicy
					When	Site.IRCalcPolicy = '2'
						Then Site.IRCalcPolicy
					When	SIMatlTypes.IRCalcPolicy = '2'
						Then SIMatlTypes.IRCalcPolicy
					Else	'1'
				End
		From	ItemSite (NoLock) Inner Join Site (NoLock)
			On ItemSite.SiteID = Site.SiteID
			Inner Join Inventory (NoLock)
			On ItemSite.InvtID = Inventory.InvtID
			Inner Join SIMatlTypes (NoLock)
			On Inventory.MaterialType = SIMatlTypes.MaterialType
		Where	ItemSite.InvtID = @InvtID
			And ItemSite.SiteID = @SiteID
GO
