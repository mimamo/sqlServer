USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Missing_InventoryADG]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Missing_InventoryADG]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will populate the InventoryADG comparison table with any records that are missing from
	the comparison table.  The Master Timestamp field will alway be defaulted to a binary zero for all
	inserted records.  This will cause the Master Timestamp not to match with the InventoryADG table insuring
	that the Inventory Item will be validated and rebuilt if that option is selected.
*/
	Set	NoCount On

	Insert	Into InventoryADG (InvtID)
	Select	Inventory.InvtID
		From	Inventory Left Join InventoryADG
			On Inventory.InvtID = InventoryADG.InvtID
		Where	InventoryADG.InvtID Is Null
			AND Inventory.InvtID LIKE @InvtIDParm
GO
