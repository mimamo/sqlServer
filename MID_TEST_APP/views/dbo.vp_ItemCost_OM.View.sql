USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vp_ItemCost_OM]    Script Date: 12/21/2015 14:26:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vp_ItemCost_OM]

As
	Select	ItemCost.*, (ItemCost.Qty - ItemCost.S4Future03) QtyCalc
		From	ItemCost
GO
