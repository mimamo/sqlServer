USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[OptDepExcl_InvtId_FeatureNbr_O]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OptDepExcl_InvtId_FeatureNbr_O]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 30 ),
	@parm4 varchar( 1 ),
	@parm5min smallint, @parm5max smallint
AS
	SELECT *
	FROM OptDepExcl
	WHERE InvtId LIKE @parm1
	   AND FeatureNbr LIKE @parm2
	   AND OptInvtID LIKE @parm3
	   AND DEType LIKE @parm4
	   AND LineNbr BETWEEN @parm5min AND @parm5max
	ORDER BY InvtId,
	   FeatureNbr,
	   OptInvtID,
	   DEType,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
