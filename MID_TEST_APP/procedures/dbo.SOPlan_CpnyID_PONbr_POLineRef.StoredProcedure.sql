USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPlan_CpnyID_PONbr_POLineRef]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPlan_CpnyID_PONbr_POLineRef]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOPlan
	WHERE CpnyID LIKE @parm1
	   AND PONbr LIKE @parm2
	   AND POLineRef LIKE @parm3
	ORDER BY CpnyID,
	   PONbr,
	   POLineRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
