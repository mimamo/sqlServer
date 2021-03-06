USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpArea_AreaID_EmployeeID]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmpArea_AreaID_EmployeeID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM smEmpArea
	WHERE AreaID LIKE @parm1
	   AND EmployeeID LIKE @parm2
	ORDER BY AreaID,
	   EmployeeID
GO
