USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOSched_QtyOrd_UnitDesc]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_PO_SOSched_QtyOrd_UnitDesc]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@LineRef varchar(5),
	@SchedRef varchar(5),
	@QtyOrd decimal(25,9) OUTPUT,
	@UnitDesc varchar(6) OUTPUT
as
	select	@QtyOrd = SOSched.QtyOrd,
		@UnitDesc = ltrim(rtrim(UnitDesc))
	from	SOSched (NOLOCK)
	join	SOLine on SOLine.CpnyID = SOSched.CpnyID and SOLine.OrdNbr = SOSched.OrdNbr and SOLine.LineRef = SOSched.LineRef
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	SOSched.LineRef = @LineRef
	and	SOSched.SchedRef = @SchedRef

	if @@ROWCOUNT = 0 begin
		set @QtyOrd = 0
		set @UnitDesc = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO
