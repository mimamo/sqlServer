USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ClearCmp_Location]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ClearCmp_Location]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will delete all records in the Location comparison table
	to force all Inventory Items to be rebuilt.
*/
	Set	NoCount On

	Delete From IN10990_Location
	WHERE IN10990_Location.InvtID LIKE @InvtIDParm
GO
