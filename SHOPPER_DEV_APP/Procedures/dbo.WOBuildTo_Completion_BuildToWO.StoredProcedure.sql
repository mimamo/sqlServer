USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_Completion_BuildToWO]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_Completion_BuildToWO]
	@WONbr		varchar( 16 ),
	@BuildToLineRef	varchar( 5 ),
	@Status		varchar( 1 )

AS
	SELECT		*
	FROM		WOBuildTo
	WHERE		BuildToWO = @WONbr
			and BuildToLineRef LIKE @BuildToLineRef
			and Status LIKE @Status
GO
