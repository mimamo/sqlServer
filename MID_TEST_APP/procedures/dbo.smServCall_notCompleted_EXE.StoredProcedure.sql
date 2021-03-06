USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_notCompleted_EXE]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_notCompleted_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
	WHERE
		ServiceCallCompleted = 0
			AND
		ServiceCallDuration = 'L'
			AND
		ServiceCallStatus = 'R'
			AND
		ServiceCallId LIKE @parm1
	ORDER BY
		ServiceCallId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
