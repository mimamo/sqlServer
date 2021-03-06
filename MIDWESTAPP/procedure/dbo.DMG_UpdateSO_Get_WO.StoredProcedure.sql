USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateSO_Get_WO]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateSO_Get_WO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)

as
	select
		b.WONbr,
		b.LineRef,
		b.QtyRemaining,
		b.QtyComplete,
		h.PlanEnd,
		h.ProcStage

	from	WOBuildTo b

	  join	WOHeader   h
	  on	h.WONbr = b.WONbr

	where	b.CpnyID = @CpnyID and
	  	b.OrdNbr = @OrdNbr and
	  	b.BuildToLineRef = @LineRef and
	  	b.BuildToType = 'ORD' and
	  	b.Status = 'P' and          	-- Planned target
	  	b.QtyComplete <> 0 and
	  	h.Status not in ('P')		-- Not Purge
GO
