USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Employee_Descr]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Employee_Descr]
	@parm1 varchar(10)
AS
	SELECT Name
	FROM Employee
	WHERE EmpId = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
