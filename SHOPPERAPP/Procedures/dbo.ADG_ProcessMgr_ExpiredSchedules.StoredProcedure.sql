USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ExpiredSchedules]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ExpiredSchedules] @TodaysDate as smalldatetime
as
	select		h.CpnyID,
			h.OrdNbr
	from		SOHeader h inner join SOType t on t.CpnyId = h.CpnyId and t.SOTypeId = h.SOTypeId
	where		h.Status = 'O' and t.Behavior in('SO', 'WC', 'MO')
			and exists(select * from SOSched s where s.CpnyId = h.CpnyId and s.OrdNbr = h.OrdNbr and s.Status = 'O' and s.CancelDate <= @TodaysDate)
GO
