USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_QOH_ExpireLotSer]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_QOH_ExpireLotSer]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	sum(l.QtyOnHand - l.QtyShipNotInv)

	from	LotSerMst l

	join	LocTable lt
	on	lt.SiteID = l.SiteID
	and	lt.WhseLoc = l.WhseLoc

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	lt.InclQtyAvail = 1
GO
