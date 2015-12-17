USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_PO]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_PO]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@LineRef	varchar(5)

as
	select	InvtID,
		SiteID

	from	PurOrdDet

	where	PONbr = @PONbr
	and	LineRef like @LineRef
--	and	CpnyID = @CpnyID
	group by
		InvtID,
		SiteID
GO
