USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WO_ProcStage]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_WO_ProcStage]
	@WONbr		varchar( 16 )
	AS
	Select		ProcStage
	From		WOHeader
	Where		WONbr = @WONbr
GO
