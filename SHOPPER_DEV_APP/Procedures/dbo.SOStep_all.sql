USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOStep_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOStep_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 4 )
AS
	SELECT *
	FROM SOStep
	WHERE CpnyID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	   AND Seq LIKE @parm3
	ORDER BY CpnyID,
	   SOTypeID,
	   Seq

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
