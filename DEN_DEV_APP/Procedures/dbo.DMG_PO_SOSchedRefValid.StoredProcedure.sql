USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOSchedRefValid]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOSchedRefValid]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	if (
	select	count(*)
	from	vp_SOSchedPO (NOLOCK)
	where	QtyOrd >= 0
	and	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef = @LineRef
	and	SchedRef = @SchedRef
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
