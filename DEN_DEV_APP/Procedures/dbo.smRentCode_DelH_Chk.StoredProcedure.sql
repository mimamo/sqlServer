USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentCode_DelH_Chk]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentCode_DelH_Chk]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smRentHeader
	WHERE
		RentalID = @parm1
	ORDER BY
		RentalID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
