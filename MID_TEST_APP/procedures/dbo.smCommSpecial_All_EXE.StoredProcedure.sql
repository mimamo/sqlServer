USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCommSpecial_All_EXE]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCommSpecial_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smCommSpecial
	WHERE
		CommSpecId LIKE @parm1
	ORDER BY
		CommSpecId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
