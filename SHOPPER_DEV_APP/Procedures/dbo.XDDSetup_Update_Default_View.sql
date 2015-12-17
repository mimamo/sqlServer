USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDSetup_Update_Default_View]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDSetup_Update_Default_View]
	@SaveType		varchar( 1 ),		-- "E"rror - save to LBViewIDError, "A"pplic - save to LBViewIDApplic
	@ViewID			varchar( 10 )

AS

	if @SaveType = 'E'
		UPDATE		XDDSetup
		Set		LBViewIDError = @ViewID
	else
		UPDATE		XDDSetup
		Set		LBViewIDApplic = @ViewID
GO
