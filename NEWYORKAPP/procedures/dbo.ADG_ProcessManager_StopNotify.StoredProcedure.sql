USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessManager_StopNotify]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessManager_StopNotify]
as
	select	*
	from	SOSetup (nolock)
GO
