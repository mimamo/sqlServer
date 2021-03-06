USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FtrDepExcl_all]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FtrDepExcl_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 1 ),
	@parm4min smallint, @parm4max smallint
AS
	SELECT *
	FROM FtrDepExcl
	WHERE InvtID LIKE @parm1
	   AND FeatureNbr LIKE @parm2
	   AND DEType LIKE @parm3
	   AND DepExclFtr BETWEEN @parm4min AND @parm4max
	ORDER BY InvtID,
	   FeatureNbr,
	   DEType,
	   DepExclFtr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
