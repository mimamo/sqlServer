USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smZipLicense_ZipID_Bus]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smZipLicense_ZipID_Bus]
		@parm1	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smZipLicense
		,smLicense
	WHERE
		smZipLicense.ZipID = @parm1
			AND
		smZipLicense.licenseid = smLicense.LicenseID
			AND
		smLicense.LicenseType = 'B'
			AND
		smZipLicense.LicenseID LIKE @parm2
	ORDER BY
		smZipLicense.ZipID
		,smZipLicense.LicenseID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
