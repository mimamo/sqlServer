USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Solomon_Employee_EmpId]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[Solomon_Employee_EmpId]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		Employee
	WHERE
		EmpId  LIKE  @parm1
	ORDER BY
		EmpId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
