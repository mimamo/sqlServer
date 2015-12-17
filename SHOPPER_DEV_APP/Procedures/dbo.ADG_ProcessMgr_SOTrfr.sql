USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOTrfr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOTrfr]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	l.InvtID,
		h.ShipSiteID

	from	SOSched s

	join	SOLine l
	on	s.CpnyID = l.CpnyID
	and	s.OrdNbr = l.OrdNbr
	and	s.LineRef = l.LineRef

	join	SOHeader h
	on	s.CpnyID = h.CpnyID
	and	s.OrdNbr = h.OrdNbr

	where	s.CpnyID = @CpnyID
	and	s.OrdNbr = @OrdNbr
	and	s.LineRef like @LineRef
	and	s.SchedRef like @SchedRef

	group by
		l.InvtID,
		h.ShipSiteID
GO
