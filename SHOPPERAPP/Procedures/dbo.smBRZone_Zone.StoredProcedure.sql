USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smBRZone_Zone]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smBRZone_Zone]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smBRZone
	WHERE
		ZoneID LIKE @parm1
	ORDER BY
		ZoneID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
