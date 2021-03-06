USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_GetItemSite_IS]    Script Date: 12/21/2015 16:00:56 ******/
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
