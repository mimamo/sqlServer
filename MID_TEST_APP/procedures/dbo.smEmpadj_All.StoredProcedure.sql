USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpadj_All]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmpadj_All]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		EmpAdjID
		,EmpAdjAmount
		,EmpAdjDocument
		,EmpAdjNotes
		,EmpAdjSalesOrder
		,EmpAdjTypeID
		,smEmpAdj.User1
		,smEmpAdj.User2
		,smEmpAdj.User3
		,smEmpAdj.User4
		,linenbr
		,EmployeeFirstName
		,EmployeeLastName
		,EmployeeMiddleInit
		,EmployeeId
	FROM
		smEmpAdj
		,smEmp
	WHERE
		empadjid = employeeId
			AND
		EmpAdjId = @parm1
			AND
		Linenbr  BETWEEN @parm2beg AND @parm2end
	ORDER BY
	EmpAdjID
	,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
