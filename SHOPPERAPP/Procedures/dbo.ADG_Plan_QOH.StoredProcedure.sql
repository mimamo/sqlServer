USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_QOH]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_QOH]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	sum(l.QtyOnHand
		- l.QtyAllocBM
		- l.QtyAllocIN
		- l.QtyAllocPORet
		- l.QtyAllocSD
		- l.QtyShipNotInv
		- case when left(isnull(WOSetup.S4Future11,' '),1) in ('F','R') then l.QtyWORlsedDemand else 0 End
		- case when left(isnull(WOSetup.S4Future11,' '),1) = 'F' then l.S4Future03 else 0 end
		)

	from	Location l

	join	LocTable lt
	on	lt.SiteID = l.SiteID
	and	lt.WhseLoc = l.WhseLoc

	left join WOSetup (nolock) on SetupID = 'WO' and Init = 'Y'

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	lt.InclQtyAvail = 1
GO
