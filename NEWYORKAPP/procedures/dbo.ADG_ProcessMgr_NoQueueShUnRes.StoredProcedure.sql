USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_NoQueueShUnRes]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_NoQueueShUnRes]
as
	select	convert(smallint, S4Future12)
	from	SOSetup (nolock)
GO
