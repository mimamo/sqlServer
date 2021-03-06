USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOLineSOSchedSelected]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOLineSOSchedSelected]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5),
	@QtyOrd		decimal(25,9) OUTPUT,
	@UnitDesc	varchar(6) OUTPUT
as
	select	@QtyOrd = SOSched.QtyOrd - SOSched.QtyShip,
		@UnitDesc = SOLine.UnitDesc
	from	SOSched (NOLOCK)
	join	SOLine on SOLine.CpnyID = SOSched.CpnyID and SOLine.OrdNbr = SOSched.OrdNbr and SOLine.LineRef = SOSched.LineRef
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	SOSched.LineRef = @LineRef
	and	SchedRef = @SchedRef

	if @@ROWCOUNT = 0
	begin
		set @QtyOrd = 0
		set @UnitDesc = ''
		--select 0
		return 0	--Failure
	end
	else
		--select 1
		return 1	--Success
GO
