USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Emp_CleanUp]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Emp_CleanUp]
@EmpId varchar(10)
AS
DELETE CalcChk
WHERE EmpID=@EmpID

DELETE CalcChkDet
WHERE EmpID=@EmpID
GO
