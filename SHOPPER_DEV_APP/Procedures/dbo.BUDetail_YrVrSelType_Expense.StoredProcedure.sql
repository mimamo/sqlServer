USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_YrVrSelType_Expense]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_YrVrSelType_Expense    Script Date: 11/13/99 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_YrVrSelType_Expense]
@Parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10),
@Parm4 varchar ( 24), @Parm5 varchar(10) AS
SELECT * FROM AcctHist, Account WHERE AcctHist.CpnyId = @Parm1 AND AcctHist.fiscyr = @Parm2
AND AcctHist.ledgerid = @Parm3 AND AcctHist.Sub Like @Parm4
AND Account.AcctType IN ('1E', '2E', '3E', '4E')
AND AcctHist.Acct LIke @Parm5 and AcctHist.Acct = Account.Acct
ORDER BY AcctHist.CPnyID, AcctHist.Acct, AcctHist.Sub, AcctHist.Ledgerid, AcctHist.FiscYr DESC
GO
