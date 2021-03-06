USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_GetBinQtyAll]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_GetBinQtyAll]
	@InvtID	varchar(30),
	@SiteID	varchar(10)
as
	select	sum(l.QtyAvail)
	from	Location  l
	join	LocTable  lt
	  on	lt.SiteID = l.SiteID
	  and	lt.WhseLoc = l.WhseLoc

	where	l.InvtID = @InvtID
	  and	l.SiteID = @SiteID
	  and	lt.InclQtyAvail = 1
GO
