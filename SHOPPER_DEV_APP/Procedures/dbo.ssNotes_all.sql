USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ssNotes_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[ssNotes_all]
		@parm1	varchar(7)
		,@parm2	varchar(30)
AS
	SELECT
		*
	FROM
		ssNotes
	WHERE
		ScreenID LIKE @parm1
	   		AND
	   	PrimaryKey LIKE @parm2
	ORDER BY
		ScreenID
		,PrimaryKey

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
