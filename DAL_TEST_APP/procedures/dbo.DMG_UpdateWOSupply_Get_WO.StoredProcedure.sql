USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateWOSupply_Get_WO]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateWOSupply_Get_WO]
	@CpnyID		varchar(10),
	@WONbr	   	varchar(16),
	@WOBTLineRef	varchar(5)
as
	IF PATINDEX('%[%]%', @WOBTLineRef) > 0
		SELECT
			b.LineRef,
			b.QtyRemaining,
			b.BuildToType,
			h.PlanEnd,
			b.OrdNbr,
			b.BuildToLineRef,
			b.InvtID,
			b.SiteID,
			h.ProcStage
			from	WOBuildTo b left outer join WOHeader h
		  	on h.WONbr = b.WONbr
			where 	b.CpnyID = @CpnyID and
		  	b.WONbr = @WONbr and
		  	b.LineRef + '' LIKE @WOBTLineRef and
	  		b.Status = 'P' and          	-- Planned target
		  	(b.BuildToType = 'ORD' or	-- Need to replan MTO on final
				(b.BuildToType <> 'ORD' and b.QtyRemaining <> 0)) and
			b.BuildToType <> 'PRJ' and	-- Never include in Build to Project/Task
		  	h.ProcStage not in ('P') and
		  	h.Status not in ('P')		-- Not Purge

		   order by b.invtid, b.siteid, h.planend
		   -- this order allows assignment of planref values
	ELSE
		SELECT
			b.LineRef,
			b.QtyRemaining,
			b.BuildToType,
			h.PlanEnd,
			b.OrdNbr,
			b.BuildToLineRef,
			b.InvtID,
			b.SiteID,
			h.ProcStage
			from	WOBuildTo b left outer join WOHeader h
		  	on h.WONbr = b.WONbr
			where 	b.CpnyID = @CpnyID and
		  	b.WONbr = @WONbr and
		  	b.LineRef = @WOBTLineRef and
	  		b.Status = 'P' and          	-- Planned target
		  	(b.BuildToType = 'ORD' or	-- Need to replan MTO on final
				(b.BuildToType <> 'ORD' and b.QtyRemaining <> 0)) and
			b.BuildToType <> 'PRJ' and	-- Never include in Build to Project/Task
		  	h.ProcStage not in ('P') and
		  	h.Status not in ('P')		-- Not Purge

		   order by b.invtid, b.siteid, h.planend
		   -- this order allows assignment of planref values
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
