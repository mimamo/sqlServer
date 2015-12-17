USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_ItemSite_QtyAlloc]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_ItemSite_QtyAlloc]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	QtyAlloc
	from	ItemSite
	where	InvtID = @InvtID
	and	SiteID = @SiteID
GO
