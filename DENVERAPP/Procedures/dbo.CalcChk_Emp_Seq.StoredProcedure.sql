USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Emp_Seq]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Emp_Seq]
@EmpId  varchar(10),
@ChkSeq varchar(2)
AS
SELECT *
FROM CalcChk
WHERE EmpID=@EmpID AND ChkSeq=@ChkSeq
GO
