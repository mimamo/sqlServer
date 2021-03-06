USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_20400_Cash_BankRec]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_20400_Cash_BankRec]
@BatNbr CHAR(10)
AS

SELECT t.* FROM CATran t
           INNER JOIN BankRec b ON
                              b.BankAcct = t.BankAcct AND
                              b.BankSub = t.BankSub AND
                              b.CpnyID = t.BankCpnyID AND
                              b.StmtDate >= t.ClearDate

WHERE t.BatNbr = @BatNbr AND
      t.rcnclstatus = 'C'
GO
