USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Upd_CalcChkDetLines_BatNbr]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Upd_CalcChkDetLines_BatNbr]
@BatNbr varchar (10),
@DD_Flag smallint
AS
UPDATE c
SET DetailLines=p.DetLines
FROM Employee e
     INNER JOIN CalcChk c
         ON c.EmpID=e.EmpID
     INNER JOIN (SELECT sum(case when @DD_Flag = 0 and Col1Type = 'D' then 0 else 1 end) as DetLines,EmpID,ChkSeq
                 FROM PRCheckTran
		 WHERE ASID = 0
                 GROUP BY EmpID, ChkSeq) p
         ON p.EmpID=c.EmpID AND p.ChkSeq=c.ChkSeq
WHERE e.CurrBatNbr=@BatNbr
GO
