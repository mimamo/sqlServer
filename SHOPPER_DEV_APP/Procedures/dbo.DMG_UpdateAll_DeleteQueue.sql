USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_DeleteQueue]    Script Date: 12/16/2015 15:55:18 ******/
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
