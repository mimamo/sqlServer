USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_Delete_ItemCost]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Proc [dbo].[DMG_10990_Delete_ItemCost]
	@InvtIDParm VARCHAR (30)
As
/*
	This procedure will delete all ItemCost records that do not have
	a corresponding IN10990_ItemCost record
*/

Delete From      ItemCost
            From     ItemCost Left Join IN10990_ItemCost
                                    On IN10990_ItemCost.InvtID = ItemCost.InvtID
                                    And IN10990_ItemCost.SiteID = ItemCost.SiteID
                                    And IN10990_ItemCost.LayerType = ItemCost.LayerType
                                    And IN10990_ItemCost.SpecificCostID = ItemCost.SpecificCostID
                                    And IN10990_ItemCost.RcptDate = ItemCost.RcptDate
                                    And IN10990_ItemCost.RcptNbr = ItemCost.RcptNbr
            Where   IN10990_ItemCost.InvtID Is Null
			AND ItemCost.InvtID LIKE @InvtIDParm
GO
