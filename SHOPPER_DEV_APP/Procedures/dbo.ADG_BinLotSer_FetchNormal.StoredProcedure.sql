USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_BinLotSer_FetchNormal]    Script Date: 12/21/2015 14:34:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_BinLotSer_FetchNormal]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@BypassAlloc	smallint = 1
as
	select	l.WhseLoc,
		'LotSerNbr' = space(25),
		'MfgrLotSerNbr' = space(25),
		'QtyAvail' = (l.QtyAvail)

	from	Location  l
	join	LocTable  lt
	on	l.SiteID = lt.SiteID
	and	l.WhseLoc = lt.WhseLoc

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	lt.InclQtyAvail = 1
	and	(l.QtyAvail + l.QtyAlloc * (1-@BypassAlloc) + l.QtyAllocSO * (1-@BypassAlloc)) > 0

	order by
		lt.PickPriority,
		QtyAvail
GO
