USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WO_ProcStage]    Script Date: 12/21/2015 15:55:27 ******/
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
