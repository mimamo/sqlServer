USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpArea_EmpID_AreaID]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmpArea_EmpID_AreaID]
	@parm1 varchar( 10 )
AS
	SELECT EmployeeID, AreaID
	FROM smEmpArea
	WHERE EmployeeID = @parm1
	ORDER BY EmployeeID, AreaID
GO
