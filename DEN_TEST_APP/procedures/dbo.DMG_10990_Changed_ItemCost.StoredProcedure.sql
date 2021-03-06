USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Changed_ItemCost]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Changed_ItemCost]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will update the ItemCost comparison table
	so that only records that have changed are flagged.
*/
	Set	NoCount On

	Update	IN10990_ItemCost
		Set Changed = 0
	WHERE IN10990_ItemCost.InvtID LIKE @InvtIDParm
		Update	IN10990_ItemCost
		Set Changed = 1
		From	ItemCost Left Join IN10990_ItemCost
			On ItemCost.InvtID = IN10990_ItemCost.InvtID
			And ItemCost.SiteID = IN10990_ItemCost.SiteID
			And ItemCost.LayerType = IN10990_ItemCost.LayerType
			And ItemCost.SpecificCostID = IN10990_ItemCost.SpecificCostID
			And ItemCost.RcptDate = IN10990_ItemCost.RcptDate
			And ItemCost.RcptNbr = IN10990_ItemCost.RcptNbr
		Where	ItemCost.tStamp <> IN10990_ItemCost.MstStamp
		AND IN10990_ItemCost.InvtID LIKE @InvtIDParm
GO
