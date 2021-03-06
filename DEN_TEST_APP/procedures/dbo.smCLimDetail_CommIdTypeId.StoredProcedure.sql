USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCLimDetail_CommIdTypeId]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCLimDetail_CommIdTypeId]
		@parm1	varchar(10)
		,@parm2 varchar(10)
		,@parm3beg	smallint
		,@parm3end	smallint
AS
	SELECT
		*
	FROM
		smCLimDetail
 	WHERE
 		CommPlanId = @parm1
			AND
		CommTypeId = @parm2
			AND
		LineNbr between @parm3beg and @parm3end
	ORDER BY
		CommPlanId
		,CommTypeId
		,CommFrom
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
