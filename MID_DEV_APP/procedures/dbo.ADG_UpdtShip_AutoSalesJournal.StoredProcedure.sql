USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_AutoSalesJournal]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_AutoSalesJournal]
as
	SELECT DfltAccrueRev, AutoSalesJournal FROM SOSetup (NOLOCK)
GO
