USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Emp_All]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Emp_All] @EmpId varchar(10) AS
    SELECT * FROM CalcChk
            WHERE EmpID=@EmpID
            ORDER BY EmpId, ChkSeq
GO
