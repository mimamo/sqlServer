USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_BatNbr]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[CalcChk_BatNbr]
@BatNbr varchar (10)
AS
SELECT c.*
FROM Employee e
     INNER JOIN CalcChk c
         ON c.EmpID=e.EmpID
WHERE e.CurrBatNbr=@BatNbr
ORDER BY c.EmpID, c.ChkSeq
GO
