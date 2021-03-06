USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOProductionCompletionCheck]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOProductionCompletionCheck]
   	@Mode		varchar(1),	-- 'S'et flag, 'G'et flag
   	@WONbr		varchar(16),
   	@Flag		smallint
as

	-- If DBProcessStatus = 1, then this WO is having Production Completion run
	If @Mode = 'G'
		-- Get the flag value for the WO
		SELECT	DBProcessStatus
		FROM	WOHeader (nolock)
		WHERE	WONbr = @WONbr
	else
		-- Set the flag value for the WO
		UPDATE	WOHeader
		SET	DBProcessStatus = @Flag
		WHERE	WONbr = @WONbr
GO
