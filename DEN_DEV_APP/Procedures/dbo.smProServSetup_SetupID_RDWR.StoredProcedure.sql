USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_SetupID_RDWR]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProServSetup_SetupID_RDWR]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smProServSetup
	WHERE
		SetupID LIKE @parm1
	ORDER BY
  		Setupid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
