USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DeleteMaint]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DeleteMaint]
as
	delete	ProcessQueue
	where	MaintMode = 1
GO
