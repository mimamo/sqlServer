USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPlan_CpnyID_SOOrdNbr_SOLineR]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPlan_CpnyID_SOOrdNbr_SOLineR]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 5 )
AS
	SELECT *
	FROM SOPlan
	WHERE CpnyID LIKE @parm1
	   AND SOOrdNbr LIKE @parm2
	   AND SOLineRef LIKE @parm3
	   AND SOSchedRef LIKE @parm4
	ORDER BY CpnyID,
	   SOOrdNbr,
	   SOLineRef,
	   SOSchedRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
