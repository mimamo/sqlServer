USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintCounters_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintCounters_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM SOPrintCounters
	WHERE CpnyID LIKE @parm1
	   AND ReportName LIKE @parm2
	ORDER BY CpnyID,
	   ReportName

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
