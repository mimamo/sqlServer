USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessManager_StopNotify]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessManager_StopNotify]
as
	select	*
	from	SOSetup (nolock)
GO
