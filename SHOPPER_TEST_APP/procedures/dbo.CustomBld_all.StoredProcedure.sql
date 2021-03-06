USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustomBld_all]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustomBld_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 30 ),
	@parm4min smallint, @parm4max smallint,
	@parm5min smallint, @parm5max smallint
AS
	SELECT *
	FROM CustomBld
	WHERE OrderNbr LIKE @parm1
	   AND ParFtrNbr LIKE @parm2
	   AND ParOptInvtID LIKE @parm3
	   AND LevelNbr BETWEEN @parm4min AND @parm4max
	   AND LineNbr BETWEEN @parm5min AND @parm5max
	ORDER BY OrderNbr,
	   ParFtrNbr,
	   ParOptInvtID,
	   LevelNbr,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
