USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ClearIN10990_Check]    Script Date: 12/21/2015 14:34:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ClearIN10990_Check]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will delete all records in the ItemSite comparison table
	to force all Inventory Items to be rebuilt.
*/
	Set	NoCount On

	Delete From IN10990_Check
	WHERE IN10990_Check.InvtID LIKE @InvtIDParm
GO
