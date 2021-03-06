USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ItemCost_SpecificCost]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ItemCost_SpecificCost]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@LayerType	VarChar(2),
	@SpecificCostID	VarChar(25)
As
	Set	NoCount On

	Select	Top 1
		*
		From	ItemCost (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And LayerType = @LayerType
			And SpecificCostID = @SpecificCostID
GO
