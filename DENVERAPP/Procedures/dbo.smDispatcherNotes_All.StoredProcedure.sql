USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smDispatcherNotes_All]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smDispatcherNotes_All]
		@parm1	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smDispatcherNotes
	WHERE
		CallType LIKE @parm1
			AND
		GeographicID LIKE @parm2
	ORDER BY
		CallType
		,GeographicID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
