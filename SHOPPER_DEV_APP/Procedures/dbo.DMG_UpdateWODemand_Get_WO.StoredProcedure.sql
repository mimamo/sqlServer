USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateWODemand_Get_WO]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateWODemand_Get_WO]
	@CpnyID		varchar(10),
	@WONbr	   	varchar(16),
	@WOTask		varchar(32),
	@WOMRLineRef	varchar(5)
as
	IF PATINDEX('%[%]%', @WOTask) > 0 OR PATINDEX('%[%]%', @WOMRLineRef) > 0
		select
			m.Task,
			m.LineRef,
			m.QtyRemaining,
			m.DateReqd,
			m.InvtID,
			m.SiteID,
			Case When h.WOType <> 'P' then h.ProcStage Else t.ProcStage End
			from	WOMatlReq m left outer join WOHeader h
		  	on h.WONbr = m.WONbr
		  	left outer join WOTask t
		  	on t.WONbr = m.WONbr and t.Task = m.Task

		where 	m.CpnyID = @CpnyID and
		  	m.WONbr = @WONbr and
		  	m.Task + '' LIKE @WOTask and
		  	m.LineRef + '' LIKE @WOMRLineRef and
		  	m.QtyRemaining <> 0 and
		  	((h.WOType <> 'P' and h.ProcStage <> 'P') or	-- WO
		  	(h.WOType = 'P' and t.ProcStage <> 'P')) and	-- PWO
		  	h.Status not in ('P')		 		-- Not Purge

   		order by m.invtid, m.siteid, m.datereqd
	   	-- this order allows assignment of planref values
	ELSE
		select
			m.Task,
			m.LineRef,
			m.QtyRemaining,
			m.DateReqd,
			m.InvtID,
			m.SiteID,
			Case When h.WOType <> 'P' then h.ProcStage Else t.ProcStage End
			from	WOMatlReq m left outer join WOHeader h
		  	on h.WONbr = m.WONbr
		  	left outer join WOTask t
		  	on t.WONbr = m.WONbr and t.Task = m.Task

		where 	m.CpnyID = @CpnyID and
		  	m.WONbr = @WONbr and
		  	m.Task = @WOTask and
		  	m.LineRef = @WOMRLineRef and
		  	m.QtyRemaining <> 0 and
		  	((h.WOType <> 'P' and h.ProcStage <> 'P') or	-- WO
		  	(h.WOType = 'P' and t.ProcStage <> 'P')) and	-- PWO
		  	h.Status not in ('P')		 		-- Not Purge

   		order by m.invtid, m.siteid, m.datereqd
	   	-- this order allows assignment of planref values
GO
