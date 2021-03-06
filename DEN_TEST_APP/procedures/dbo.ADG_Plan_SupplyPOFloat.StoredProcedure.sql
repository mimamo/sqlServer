USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyPOFloat]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyPOFloat]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	l.PONbr,
		l.LineRef,
		'AllocRef' = space(5),
		l.QtyOrd,
		l.QtyRcvd,
		l.CnvFact,
		l.UnitMultDiv,
		l.PromDate,
		h.CpnyID,
		'SOOrdNbr' = space(15),
		'SOLineRef' = space(5),
		'SOSchedRef' = space(5),
--		l.ShelfLife
		convert(smallint, l.S4Future09)	-- ShelfLife (temporary)

	from	PurOrdDet l
	join	PurchOrd h
	on	l.PONbr = h.PONbr

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	l.PurchaseType in ('GI', 'GN')	-- Goods for Inventory, Non-Inventory Goods
	and	l.OpenLine = 1
	and	h.POType = 'OR'
	and	h.Status in ('O', 'P')	-- Open Order, Purchase Order

	order by
		l.PromDate
GO
