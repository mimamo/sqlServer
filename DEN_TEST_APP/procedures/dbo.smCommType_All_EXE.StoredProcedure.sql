USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCommType_All_EXE]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCommType_All_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smCommType
	WHERE
		CommTypeId LIKE @parm1
	ORDER BY
		CommTypeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
