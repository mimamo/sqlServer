USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_Init]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_Init]
as
	select	*
	from	ProcessQueue
	where	ProcessType = ''
GO
