USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_InvtID_SiteID]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_ItemSite_InvtID_SiteID]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10)
	As
	Select	*
		From	ItemSite (NoLock)
		Where	InvtID = @InvtID
			And SiteID Like @SiteID
			order by InvtId, SiteId
GO
