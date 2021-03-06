USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOVoidInvc_all]    Script Date: 12/21/2015 14:18:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOVoidInvc_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 15 )
AS
	SELECT *
	FROM SOVoidInvc
	WHERE CpnyID LIKE @parm1
	   AND ReportName LIKE @parm2
	   AND InvcNbr LIKE @parm3
	ORDER BY CpnyID,
	   ReportName,
	   InvcNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
