USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_POObsolete]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_POObsolete]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@LineRef	varchar(5)
as
	select	p.InvtID,
		p.SiteID

	from	SOPlan	p

	join	PurOrdDet l
	on	l.PONbr = @PONbr
	and	l.LineRef = @LineRef

	where	p.PONbr = @PONbr
	and	p.POLineRef like @LineRef
	and	p.CpnyID = @CpnyID
	and	((p.InvtID <> l.InvtID) or (p.SiteID <> l.SiteID))

	group by
		p.InvtID,
		p.SiteID
GO
