USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_All]
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
	ORDER BY
		ServiceCallId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
