USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentCode_Del_Chk]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentCode_Del_Chk]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smRentDetail
	WHERE
		RentalID = @parm1
	ORDER BY
		RentalID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
