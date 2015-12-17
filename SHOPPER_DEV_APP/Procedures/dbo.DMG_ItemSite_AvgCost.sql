USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSite_AvgCost]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ItemSite_AvgCost]

	@InvtID varchar(30),
	@SiteID varchar(10)
as
	select	AvgCost
	from	ItemSite
	where	InvtID = @InvtID
	and	SiteID = @SiteID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
