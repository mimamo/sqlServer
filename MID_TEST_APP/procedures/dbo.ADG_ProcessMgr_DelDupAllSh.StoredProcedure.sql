USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelDupAllSh]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelDupAllSh]
	@QueueID	int
as
	delete	from ProcessQueue
	where	ProcessQueueID <> @QueueID
	and	ProcessType = 'ALLSH'
GO
