USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSetup_UpdateOrderAfterShippers]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSetup_UpdateOrderAfterShippers]
as
	SELECT DelayUpdOrd From SOSetup
GO
