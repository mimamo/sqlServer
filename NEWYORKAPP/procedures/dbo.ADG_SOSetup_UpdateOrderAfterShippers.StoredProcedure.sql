USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSetup_UpdateOrderAfterShippers]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSetup_UpdateOrderAfterShippers]
as
	SELECT DelayUpdOrd From SOSetup
GO
