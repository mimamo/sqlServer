USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smRentCodes_All]    Script Date: 12/21/2015 16:01:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentCodes_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smRentCodes
	WHERE
		RentalID LIKE @parm1
	ORDER BY
		RentalId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
