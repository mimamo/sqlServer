USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_BatNbr_By_PG]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[CalcChk_BatNbr_By_PG]
@BatNbr varchar (10)
AS
SELECT c.*
FROM Employee e
     INNER JOIN CalcChk c
         ON c.EmpID=e.EmpID
WHERE e.CurrBatNbr=@BatNbr
ORDER BY e.PayGrpId, c.EmpID, c.ChkSeq
GO
