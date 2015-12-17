USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpPhone_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmpPhone_All]
		@parm1	varchar(10)
		,@parm2 varchar(30)
AS
	SELECT
		*
	FROM
		smEmpPhone
	WHERE
		EmpID = @parm1
			AND
		PhoneType LIKE @parm2
	ORDER BY
		EmpID
		,PhoneType

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
