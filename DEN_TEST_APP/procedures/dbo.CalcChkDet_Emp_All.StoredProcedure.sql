USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_All]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChkDet_Emp_All]
@EmpId varchar(10)
AS
SELECT *
FROM CalcChkDet
WHERE EmpID=@EmpID
GO
