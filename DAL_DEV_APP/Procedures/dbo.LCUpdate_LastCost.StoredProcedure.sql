USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCUpdate_LastCost]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[LCUpdate_LastCost]
	@InvtID varchar (30),
	@SiteID varchar(10),
	@NewCost float
as
UPdate ItemSite
	Set LastCost = @NewCost
Where
	Invtid = @InvtID
	And SiteID = @SiteId
GO
