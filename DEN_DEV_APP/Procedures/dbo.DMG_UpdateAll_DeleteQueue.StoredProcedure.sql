USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_DeleteQueue]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_DeleteQueue]
as
	delete
	from		ProcessQueue
	where		ProcessCPSOff = 1 and
			ProcessType <> 'MAINT'
GO
