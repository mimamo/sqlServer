USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Init]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Init]
	@ComputerName		varchar(21)
as
	delete from SOPlan
		delete from INUpdateQty_Wrk
	where ComputerName = @ComputerName
GO
