USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCallStatus_All]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCallStatus_All]
		@parm1 varchar(10)

AS
	SELECT
		*
	FROM
		smCallStatus
	WHERE
		CallStatusId LIKE @parm1
	ORDER BY
		CallStatusId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
