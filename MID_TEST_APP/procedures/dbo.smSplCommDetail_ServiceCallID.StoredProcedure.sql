USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSplCommDetail_ServiceCallID]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSplCommDetail_ServiceCallID]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smSplCommDetail
	left outer join smEmp
		on smSplCommDetail.EmpID = smEmp.EmployeeId
WHERE ServiceCallID = @parm1
	AND EmpID LIKE @parm2
ORDER BY ServiceCallID
	,EmpID
GO
