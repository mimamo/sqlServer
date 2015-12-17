USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_WODemand]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_WODemand]
as
	select		CpnyID, WONbr
	from		WOHeader
	where		Status not in ('P')		 	-- Not Purge
	order by	WONbr								-- For Demand cannot constrain on Proc Stage (PWOs)
GO
