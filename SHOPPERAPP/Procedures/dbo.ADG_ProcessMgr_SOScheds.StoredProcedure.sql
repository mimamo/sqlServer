USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOScheds]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOScheds]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),	-- can be wildcard
	@SchedRef	varchar(5)	-- can be wildcard
as
	select	LineRef,
		SchedRef

	from	SOSched

	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef + '' like @LineRef
	and	SchedRef + '' like @SchedRef
GO
