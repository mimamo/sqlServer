USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCode_All_EXE]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCode_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smCode
	WHERE
		Fault_Id LIKE @parm1
	ORDER BY
		Fault_Id

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
