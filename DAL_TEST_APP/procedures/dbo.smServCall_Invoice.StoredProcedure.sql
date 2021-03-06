USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_Invoice]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_Invoice]
		@parm1	varchar(1)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
	WHERE
		ServiceCallCompleted = CONVERT(int,@parm1)
			AND
		ServiceCallId LIKE @parm2
			AND
		ServiceCallStatus in ('R','C')
	ORDER BY
		ServiceCallId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
