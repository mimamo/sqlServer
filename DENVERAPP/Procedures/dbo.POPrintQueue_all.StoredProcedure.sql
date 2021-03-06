USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POPrintQueue_all]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POPrintQueue_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM POPrintQueue
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND CpnyID LIKE @parm2
	   AND PONbr LIKE @parm3
	ORDER BY RI_ID,
	   CpnyID,
	   PONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
