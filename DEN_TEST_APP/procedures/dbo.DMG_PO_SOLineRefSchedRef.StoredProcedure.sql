USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOLineRefSchedRef]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOLineRefSchedRef]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5) OUTPUT
as
	select	@SchedRef = SchedRef
	from	SOSched (NOLOCK)
	where	QtyOrd >= 0
	and	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef = @LineRef

	if @@ROWCOUNT <> 1
	begin
		set @SchedRef = ''
		--select @SchedRef
		return 0	--Failure
	end
	else
		--select @SchedRef
		return 1	--Success
GO
