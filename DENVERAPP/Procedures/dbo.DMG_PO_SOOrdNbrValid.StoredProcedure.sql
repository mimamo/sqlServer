USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOOrdNbrValid]    Script Date: 12/21/2015 15:42:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOOrdNbrValid]
	@InvtID varchar(30),
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
as
	if (
	select	count(*)
	from	SOLine l (NOLOCK)
	join	SOHeader h (NOLOCK) on h.CpnyID = l.CpnyID and h.OrdNbr = l.OrdNbr
	join	SOType t (NOLOCK) on t.CpnyID = h.CpnyID and t.SOTypeID = h.SOTypeID
	join	vp_SOSchedPO s (NOLOCK) on s.CpnyID = l.CpnyID and s.OrdNbr = l.OrdNbr and s.LineRef = l.LineRef
	where	l.Status = 'O'
	and 	l.InvtID = @InvtID
	and	l.QtyOrd >= 0
	and	t.Behavior in ('SO','CS','INVC','WO','RMSH','WC')
	and	l.CpnyID = @CpnyID
	and	l.OrdNbr = @OrdNbr
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
