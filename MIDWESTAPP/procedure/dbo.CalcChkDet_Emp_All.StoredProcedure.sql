USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_All]    Script Date: 12/21/2015 15:55:23 ******/
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
