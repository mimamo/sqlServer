USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetup_LBUseCheckDate_Update]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDSetup_LBUseCheckDate_Update]
	@UseCheckDate	smallint
AS
	UPDATE XDDSetup 
	SET	LBUseCheckDate = @UseCheckDate
GO
