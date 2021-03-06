USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vp_INCheck_Location]    Script Date: 12/21/2015 13:56:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	View [dbo].[vp_INCheck_Location]
As
/*
	This view will return a summarized view of the standardized Inventory detail transactions 
	specific for the Location table.
*/
	Select	Location.InvtID, 
		QtyOnHand = Round(Sum(Coalesce(Inc.Qty, 0)), Pl.DecPlQty),
		Location.SiteID, 
		Location.WhseLoc
		From	vp_DecPl Pl,
			Location Join IN10990_Check Inc
			On	Location.InvtID = Inc.InvtID
				And Location.SiteID = Inc.SiteID
				And Location.WhseLoc = Inc.WhseLoc
			Join	Inventory
			On	Location.InvtID = Inventory.InvtID
		Where	(Inc.TranType Not In ('AB', 'AS', 'CM', 'DM', 'II', 'IN', 'PI', 'RI', 'TR')
			Or (Inc.TranType In ('AB') 
			And Inventory.LotSerTrack In ('LI', 'SI')
			And DataLength(RTrim(Inc.LotSerNbr)) = 0)
			Or (Inc.TranType In ('AB') 
			And Inventory.LotSerTrack Not In ('LI', 'SI')))
		Group By Location.InvtID, Location.SiteID, Location.WhseLoc, Pl.DecPlQty
GO
