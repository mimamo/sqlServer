USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_Priority_ID]    Script Date: 12/21/2015 13:44:43 ******/
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
