USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintControl_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintControl_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 4 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM SOPrintControl
	WHERE CpnyID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	   AND Seq LIKE @parm3
	   AND SiteID LIKE @parm4
	ORDER BY CpnyID,
	   SOTypeID,
	   Seq,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
