USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintQueue_CpnyID_OrdNbr_S4F]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintQueue_CpnyID_OrdNbr_S4F]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM SOPrintQueue
	WHERE CpnyID LIKE @parm1
	   AND OrdNbr LIKE @parm2
	   AND S4Future11 LIKE @parm3
	ORDER BY CpnyID,
	   OrdNbr,
	   S4Future11

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
