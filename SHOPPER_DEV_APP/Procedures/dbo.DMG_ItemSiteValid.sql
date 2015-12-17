USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSiteValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ItemSiteValid]
	@InvtID varchar(30),
	@SiteID varchar(10)
as
	if (
	select	count(*)
	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
