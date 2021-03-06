USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOLineRefValid]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOLineRefValid]
	@InvtID		varchar(30),
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
as
	if (
	select	count(*)
	from	vp_SOSchedPO sos (NOLOCK)
	join	SOLine sol (NOLOCK) on sol.CpnyID = sos.CpnyID and sol.OrdNbr = sos.OrdNbr and sol.LineRef = sos.LineRef
	where	sol.InvtID = @InvtID
	and	sos.QtyOrd >= 0
	and	sos.CpnyID = @CpnyID
	and	sos.OrdNbr = @OrdNbr
	and	sos.LineRef = @LineRef
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
