USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_GetItemSite_IS]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_GetItemSite_IS]
	@InvtIDParm		varchar(30),
	@SiteIDParm		varchar(10)
as
	select		invtid, siteid
	from		ItemSite
	where 		InvtID like @InvtIDParm and SiteID like @SiteIDParm
	order by	invtid, siteid
GO
