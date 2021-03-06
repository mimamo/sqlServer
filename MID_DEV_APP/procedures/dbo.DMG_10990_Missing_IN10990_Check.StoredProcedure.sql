USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Missing_IN10990_Check]    Script Date: 12/21/2015 14:17:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Missing_IN10990_Check]
As
/*
	This procedure will populate the IN10990_Check comparison table with any records that are missing from
	the comparison table.  The Master Timestamp field will alway be defaulted to a binary zero for all
	inserted records.  This will cause the Master Timestamp not to match with the IN10990_Check table insuring
	that the Inventory Item will be validated and rebuilt if that option is selected.
*/
	Set	NoCount On

	Insert	Into IN10990_Check (InvtID)
	Select	Inventory.InvtID
		From	Inventory Left Join IN10990_Check
			On Inventory.InvtID = IN10990_Check.InvtID
		Where	IN10990_Check.InvtID Is Null
GO
