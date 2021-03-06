USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_01530_Cash_BankRec_Date]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_01530_Cash_BankRec_Date]
	@BatNbr char(10),
	@Module char(2),
	@Date smalldatetime AS
SELECT t.* FROM GLTran t
INNER JOIN CashAcct a ON t.Acct = a.BankAcct AND t.CpnyID = a.CpnyID AND t.Sub = a.BankSub AND a.Active = 1 AND a.AcceptGLUpdates = -1
INNER JOIN BankRec b ON a.BankAcct = b.BankAcct AND a.BankSub = b.BankSub AND a.CpnyID = b.CpnyID AND b.StmtDate >= @Date
INNER JOIN CASetup s ON s.AcceptTransDate <= @Date
WHERE t.S4Future11 <> 'O' AND t.BatNbr = @BatNbr AND t.Module = @Module
GO
