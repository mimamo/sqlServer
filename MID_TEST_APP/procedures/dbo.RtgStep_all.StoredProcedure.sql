USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_all]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RtgStep_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4min smallint, @parm4max smallint
AS
	SELECT *
	FROM RtgStep
	WHERE KitID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND RtgStatus LIKE @parm3
	   AND LineNbr BETWEEN @parm4min AND @parm4max
	ORDER BY KitID,
	   SiteID,
	   RtgStatus,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
