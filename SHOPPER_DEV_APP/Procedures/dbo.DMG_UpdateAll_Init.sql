USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Init]    Script Date: 12/16/2015 15:55:18 ******/
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
