USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ItemCost_LIFO]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ItemCost_LIFO]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@LayerType	VarChar(2)
As
	Set	NoCount On

	Select	Top 1
		*
		From	ItemCost (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And LayerType = @LayerType
			And RcptNbr <> 'OVRSLD'
		Order By RcptDate Desc, RcptNbr Desc
GO
