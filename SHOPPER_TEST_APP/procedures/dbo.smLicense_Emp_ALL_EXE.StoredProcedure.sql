USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smLicense_Emp_ALL_EXE]    Script Date: 12/21/2015 16:07:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smLicense_Emp_ALL_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smLicense
	WHERE
		LicenseType = 'E'
			AND
		LicenseID LIKE @parm1
	ORDER BY
		LicenseID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
