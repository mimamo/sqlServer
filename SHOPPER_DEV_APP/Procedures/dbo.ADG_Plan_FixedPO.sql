USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_FixedPO]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_FixedPO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	a.PONbr,
		a.POLineRef,
		a.AllocRef,
		a.QtyOrd,
		a.QtyRcvd,
		l.CnvFact,
		l.UnitMultDiv,
		l.PromDate

	from	POAlloc a

	join	PurOrdDet l
	on	l.PONbr = a.PONbr
	and	l.LineRef = a.POLineRef

	join	PurchOrd h
	on	h.PONbr = a.PONbr

	where	a.CpnyID = @CpnyID
	and	a.SOOrdNbr = @OrdNbr
	and	a.SOLineRef = @LineRef
	and	a.SOSchedRef = @SchedRef
	and	h.POType = 'OR'
	and	h.Status not in ('Q', 'X')	-- Quote, Cancelled
GO
