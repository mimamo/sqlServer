USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmp_Active]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmp_Active]
	@parm1 varchar(10)
AS
SELECT * FROM smEmp
	WHERE
		EmployeeId LIKE @Parm1 AND
		EmployeeActive = 1
	ORDER BY
		EmployeeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
