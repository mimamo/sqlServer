USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_Delete]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_Delete]
	@QueueID	int
as
	delete	ProcessQueue
	where	ProcessQueueID = @QueueID
GO
