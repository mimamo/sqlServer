USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_UpdTStamp_ItemCost]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_UpdTStamp_ItemCost]
	@InvtIDParm	VARCHAR (30)
As
/*
	This procedure will update the ItemCost comparison table by clearing the changed flag
	on all previous changed records, and updates the Master TimeStamp field from the TimeStamp
	from the ItemCost table.
*/
	Set	NoCount On

	Update	IN10990_ItemCost
		Set	MstStamp = ItemCost.tStamp,
			Changed = 0
		From	ItemCost Join IN10990_ItemCost
			On ItemCost.InvtID = IN10990_ItemCost.InvtID
			And ItemCost.SiteID = IN10990_ItemCost.SiteID
			And ItemCost.LayerType = IN10990_ItemCost.LayerType
			And ItemCost.SpecificCostID = IN10990_ItemCost.SpecificCostID
			And ItemCost.RcptDate = IN10990_ItemCost.RcptDate
			And ItemCost.RcptNbr = IN10990_ItemCost.RcptNbr
		Where	ItemCost.tStamp <> IN10990_ItemCost.MstStamp
			AND IN10990_ItemCost.InvtID LIKE @InvtIDParm
GO
