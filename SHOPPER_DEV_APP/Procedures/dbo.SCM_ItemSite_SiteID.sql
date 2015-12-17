USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemSite_SiteID]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_ItemSite_SiteID]
	@CpnyID		VarChar(10),
	@SiteID		VarChar(10),
	@InvtID		VarChar(30)
As
	Select	*
		From	ItemSite (NoLock)
		Where	CpnyID = @CpnyID
			And SiteID = @SiteID
			And InvtID Like @InvtID
GO
