USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProUserConfig_SetupID]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProUserConfig_SetupID]
		@parm1 	varchar(47)
AS
	SELECT
		*
	FROM
		smProUserConfig
	WHERE
		UserID LIKE @parm1
			AND
		SetupID LIKE 'PROSETUP'
	ORDER BY
		SetupID
		,UserID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
