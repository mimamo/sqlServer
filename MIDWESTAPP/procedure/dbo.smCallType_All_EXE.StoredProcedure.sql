USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smCallType_All_EXE]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCallType_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smCallTypes
	WHERE
		CallTypeId LIKE @parm1
	ORDER BY
		CallTypeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
