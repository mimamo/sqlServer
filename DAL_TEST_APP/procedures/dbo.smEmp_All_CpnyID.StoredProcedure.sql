USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmp_All_CpnyID]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmp_All_CpnyID]
		@parm1 varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smEmp
	WHERE
		CpnyID = @parm1
			AND
		EmployeeId LIKE @parm2
	ORDER BY
		EmployeeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
