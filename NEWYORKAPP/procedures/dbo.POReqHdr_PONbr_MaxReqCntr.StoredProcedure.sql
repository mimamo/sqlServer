USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_PONbr_MaxReqCntr]    Script Date: 12/21/2015 16:01:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_PONbr_MaxReqCntr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	-- Need to do these casts because we want the numeric max.
	-- The char max thinks '9' is bigger than '10'.
	SELECT 	CAST( MAX( CAST(ReqCntr AS INTEGER) ) AS CHAR(2) )
	FROM 	POReqHdr
	WHERE 	CpnyID = @parm1
	  AND 	PONbr = @Parm2

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
