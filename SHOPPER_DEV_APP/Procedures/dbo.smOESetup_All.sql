USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smOESetup_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smOESetup_All]
		@parm1	varchar(2)
AS
	SELECT
		*
	FROM
		OESetup
	WHERE
		SetupId LIKE @parm1
	ORDER BY
		SetupId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
