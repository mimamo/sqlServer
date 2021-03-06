USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOType_CpnyID_SOTypeID_Behavio]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOType_CpnyID_SOTypeID_Behavio]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 4 )
AS
	SELECT *
	FROM SOType
	WHERE CpnyID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	   AND Behavior LIKE @parm3
	ORDER BY CpnyID,
	   SOTypeID,
	   Behavior

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
