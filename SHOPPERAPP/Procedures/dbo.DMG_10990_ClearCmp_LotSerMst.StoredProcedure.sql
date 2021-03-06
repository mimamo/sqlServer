USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_ClearCmp_LotSerMst]    Script Date: 12/21/2015 16:13:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_ClearCmp_LotSerMst]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will delete all records in the LotSerMst comparison table
	to force all Inventory Items to be rebuilt.
*/
	Set	NoCount On

	Delete From IN10990_LotSerMst
	WHERE IN10990_LotSerMst.InvtID LIKE @InvtIDParm
GO
