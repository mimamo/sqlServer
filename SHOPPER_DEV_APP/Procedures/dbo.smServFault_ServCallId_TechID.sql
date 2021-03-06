USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_ServCallId_TechID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServFault_ServCallId_TechID]
		@parm1	varchar(10)
AS
	SELECT
		DISTINCT ServiceCallId, Empid, smEmp.EmployeePagerNo, smEmp.EmployeeLastName, smEmp.EmployeeFirstName
	FROM
		smServFault, smEmp
	WHERE
		Empid <> '' AND
		ServiceCallId LIKE @parm1 AND
		Empid = smEmp.EmployeeId
	ORDER BY
		ServiceCallId, Empid
GO
