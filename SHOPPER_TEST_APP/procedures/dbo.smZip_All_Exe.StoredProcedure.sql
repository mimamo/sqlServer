USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smZip_All_Exe]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smZip_All_Exe]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smZipCode
	WHERE
		ZipId LIKE @parm1
	ORDER BY
		ZipId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
