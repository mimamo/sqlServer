USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_GetItemSite]    Script Date: 12/21/2015 15:49:16 ******/
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
