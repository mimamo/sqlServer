USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEmp_Active_Cpnyid]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmp_Active_Cpnyid]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT * FROM smEmp
	WHERE
		CpnyID = @parm1 AND
		EmployeeId LIKE @Parm2 AND
		EmployeeActive = 1
	ORDER BY
		EmployeeId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
