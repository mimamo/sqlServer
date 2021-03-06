USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[OptDepExcl_all]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OptDepExcl_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 30 ),
	@parm4 varchar( 1 ),
	@parm5 varchar( 4 ),
	@parm6 varchar( 30 )
AS
	SELECT *
	FROM OptDepExcl
	WHERE InvtId LIKE @parm1
	   AND FeatureNbr LIKE @parm2
	   AND OptInvtID LIKE @parm3
	   AND DEType LIKE @parm4
	   AND DepExclFtr LIKE @parm5
	   AND DepExclOpt LIKE @parm6
	ORDER BY InvtId,
	   FeatureNbr,
	   OptInvtID,
	   DEType,
	   DepExclFtr,
	   DepExclOpt

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
