USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOSplitLine_all]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOSplitLine_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM SOSplitLine
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND LineRef LIKE @parm3
	   AND SlsperId LIKE @parm4
	ORDER BY CpnyID,
	   OrdNbr,
	   LineRef,
	   SlsperId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
