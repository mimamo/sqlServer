USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POPolicyAppr_all]    Script Date: 12/21/2015 13:57:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POPolicyAppr_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 2 ),
	@parm3 varchar( 2 ),
	@parm4 varchar( 10 ),
	@parm5 varchar( 2 ),
	@parm6min smalldatetime, @parm6max smalldatetime
AS
	SELECT *
	FROM POPolicyAppr
	WHERE PolicyID LIKE @parm1
	   AND DocType LIKE @parm2
	   AND RequestType LIKE @parm3
	   AND MaterialType LIKE @parm4
	   AND Authority LIKE @parm5
	   AND EffDate BETWEEN @parm6min AND @parm6max
	ORDER BY PolicyID,
	   DocType,
	   RequestType,
	   MaterialType,
	   Authority,
	   EffDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
