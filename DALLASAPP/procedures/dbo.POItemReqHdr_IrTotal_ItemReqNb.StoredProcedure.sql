USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHdr_IrTotal_ItemReqNb]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHdr_IrTotal_ItemReqNb]
	@parm1min float, @parm1max float,
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM POItemReqHdr
	WHERE IrTotal BETWEEN @parm1min AND @parm1max
	   AND ItemReqNbr LIKE @parm2
	ORDER BY IrTotal,
	   ItemReqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
