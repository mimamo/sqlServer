USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smZip_Possible_Zone]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smZip_Possible_Zone]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smZipCode
	WHERE
		smZipCode.ZipId not in (SELECT AreaZipCode FROM smAreaZips )
			AND
		smZipCode.ZipID LIKE @parm1
	ORDER BY
		smZipCode.ZipID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
