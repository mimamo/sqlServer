USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_GetItemSite]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_GetItemSite]
as
	select		invtid, siteid
	from		ItemSite
	order by	invtid, siteid
GO
