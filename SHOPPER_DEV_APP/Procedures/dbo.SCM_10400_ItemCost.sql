USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ItemCost]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ItemCost]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@LayerType	VarChar(2),
	@SpecificCostID	VarChar(25),
	@RcptDate	SmallDateTime,
	@RcptNbr	VarChar(15)
As
	Select	Top 1
		*
		From	ItemCost (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And LayerType = @LayerType
			And SpecificCostID = @SpecificCostID
			And RcptDate = @RcptDate
			And RcptNbr = @RcptNbr
GO
