USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelLog]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelLog]
	@CutoffDate	smalldatetime
as
	delete	ProcessLog
	where	LogDateTime < @CutoffDate
GO
