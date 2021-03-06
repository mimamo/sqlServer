USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemSite_SiteID]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ItemSite_SiteID]
	@InvtID varchar(30),
	@SiteID varchar(10) OUTPUT
as
	--The site id will be blank unless there is only one ItemSite record
	set @SiteID = ''

	--Get the count of the ItemSite records for the inventory item
	if (
	select	count(*)
	from	ItemSite (NOLOCK)
	where	InvtID = @InvtID
	) = 1
		--Return the site id from the one record if there is only one
		select	@SiteID = SiteID
		from	ItemSite (NOLOCK)
		where	InvtID = @InvtID

	--select @SiteID
GO
