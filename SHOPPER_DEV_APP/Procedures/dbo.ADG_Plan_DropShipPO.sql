USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_DropShipPO]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_DropShipPO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	a.PONbr,
		a.POLineRef,
		a.AllocRef

	from	POAlloc a

	where	a.CpnyID = @CpnyID
	and	a.SOOrdNbr = @OrdNbr
	and	a.SOLineRef = @LineRef
	and	a.SOSchedRef = @SchedRef
GO
