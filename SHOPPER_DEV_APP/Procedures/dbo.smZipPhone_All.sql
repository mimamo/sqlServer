USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smZipPhone_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smZipPhone_All]
		@parm1	varchar(10)
		,@parm2 varchar(20)
AS
	SELECT
		*
	FROM
		smZipPhone
	WHERE
		ZipId = @parm1
			AND
		ZipPhoneType LIKE @parm2
	ORDER BY
		ZipId
		,ZipPhoneType

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
