USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Changed_ItemSite]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Changed_ItemSite]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will update the ItemSite comparison table
	so that only records that have changed are flagged.
*/
	Set	NoCount On

	Update	IN10990_ItemSite
		Set Changed = 0
	WHERE IN10990_ItemSite.InvtID LIKE @InvtIDParm

	Update	IN10990_ItemSite
		Set Changed = 1
		From	ItemSite Left Join IN10990_ItemSite
			On ItemSite.InvtID = IN10990_ItemSite.InvtID
			And ItemSite.SiteID = IN10990_ItemSite.SiteID
			And ItemSite.CpnyID = IN10990_ItemSite.CpnyID
		Where	ItemSite.tStamp <> IN10990_ItemSite.MstStamp
			AND IN10990_ItemSite.InvtID LIKE @InvtIDParm
GO
