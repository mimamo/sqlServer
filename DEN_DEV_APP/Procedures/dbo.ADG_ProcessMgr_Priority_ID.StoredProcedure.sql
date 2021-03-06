USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_Priority_ID]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_ProcessMgr_Priority_ID]
	@ServerTimeStr	varchar(20)
as
	select		top 1 *
	from		ProcessQueue
	where		ProcessAt <= @ServerTimeStr
	order by	ProcessPriority,
			ProcessQueueID
GO
