USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Emp_All]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Emp_All] @EmpId varchar(10) AS
    SELECT * FROM CalcChk
            WHERE EmpID=@EmpID
            ORDER BY EmpId, ChkSeq
GO
