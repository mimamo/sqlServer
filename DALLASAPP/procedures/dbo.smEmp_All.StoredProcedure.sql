USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEmp_All]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmp_All]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smEmp (NOLOCK)
	WHERE
		EmployeeId LIKE @parm1
	ORDER BY
		EmployeeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
