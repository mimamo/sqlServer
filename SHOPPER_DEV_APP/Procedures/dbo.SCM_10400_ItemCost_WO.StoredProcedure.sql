USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ItemCost_WO]    Script Date: 12/21/2015 14:34:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ItemCost_WO]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt,
	@QtyOnWO	Float Output,
	@CostOnWO	Float Output,
	@BMICostOnWO	Float Output
As
	Select	@QtyOnWO = Coalesce(Round(Sum(ItemCost.Qty), @DecPlQty), 0),
		@CostOnWO = Coalesce(Round(Sum(ItemCost.TotCost), @BaseDecPl), 0),
		@BMICostOnWO = Coalesce(Round(Sum(ItemCost.BMITotCost), @BMIDecPl), 0)
		From	ItemCost (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And LayerType = 'W'
GO
