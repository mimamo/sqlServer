USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_QOH]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_QOH]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@TotalQty	decimal(25,9) OUTPUT
as
	select	@TotalQty = coalesce(sum(l.QtyOnHand - l.QtyShipNotInv), 0)
	from	Location l (NOLOCK)
	join	LocTable lt (NOLOCK)
	  on	lt.SiteID = l.SiteID
	  and	lt.WhseLoc = l.WhseLoc
	where	l.InvtID = @InvtID
	  and	l.SiteID = @SiteID
	  and	lt.InclQtyAvail = 1
GO
