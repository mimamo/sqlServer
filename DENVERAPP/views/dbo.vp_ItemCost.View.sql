USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vp_ItemCost]    Script Date: 12/21/2015 15:42:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vp_ItemCost]
As
	Select	ItemCost.InvtID,
		ItemCost.SiteID,
		LayerType = Case When DataLength(RTrim(ItemCost.LayerType)) = 0 Then 'S' Else ItemCost.LayerType End,
		ItemCost.SpecificCostID,
		ItemCost.RcptNbr, 
		ItemCost.RcptDate, ItemCost.Qty, ItemCost.UnitCost, ItemCost.TotCost 
		From	ItemCost
GO
