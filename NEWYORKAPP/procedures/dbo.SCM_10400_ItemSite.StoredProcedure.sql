USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ItemSite]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ItemSite]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt
As
	Select	*
		From	ItemSite (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
GO
