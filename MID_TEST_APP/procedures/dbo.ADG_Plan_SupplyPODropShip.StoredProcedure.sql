USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyPODropShip]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyPODropShip]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	a.PONbr,
		a.POLineRef,
		a.AllocRef,
		a.QtyOrd,
		a.QtyRcvd,
		l.CnvFact,
		l.UnitMultDiv,
		l.PromDate,
		a.CpnyID,
		a.SOOrdNbr,
		a.SOLineRef,
		a.SOSchedRef,
		'ShelfLife' = convert(smallint,0)

	from	POAlloc a

	join	PurOrdDet l
	on	l.PONbr = a.PONbr
	and	l.LineRef = a.POLineRef

	join	PurchOrd h
	on	a.PONbr = h.PONbr

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	l.PurchaseType = 'GD'	-- Goods for drop Ship
	and	l.OpenLine = 1
	and	h.POType in ('DP', 'OR')
	and	h.Status in ('O', 'P')
GO
