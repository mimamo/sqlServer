USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SO]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	l.InvtID,
		s.SiteID

	from	SOSched	s

	join	SOLine	l
	on	s.CpnyID = l.CpnyID
	and	s.OrdNbr = l.OrdNbr
	and	s.LineRef = l.LineRef

	where	s.CpnyID = @CpnyID
	and	s.OrdNbr = @OrdNbr
	and	s.LineRef + '' like @LineRef
	and	s.SchedRef + '' like @SchedRef

	group by
		l.InvtID,
		s.SiteID
GO
