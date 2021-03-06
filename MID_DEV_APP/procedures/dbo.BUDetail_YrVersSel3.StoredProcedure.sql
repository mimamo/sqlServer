USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_YrVersSel3]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_YrVersSel3    Script Date: 11/13/99 12:38:58 PM ******/
/*** Stored Procedures below return Budget Ledger accthist only  ***/
CREATE PROCEDURE [dbo].[BUDetail_YrVersSel3]
@parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10), @Parm4 varchar ( 24), @Parm5 varchar(10) AS
SELECT * FROM Accthist, Account WHERE Cpnyid = @parm1 And fiscyr = @Parm2 And LedgerID = @Parm3
And AcctHist.Sub Like @Parm4 and AcctHist.Acct Like @Parm5 and Accthist.Acct = Account.Acct
ORDER BY AcctHist.CPnyID, AcctHist.Acct, AcctHist.Sub, AcctHist.Ledgerid, AcctHist.FiscYr DESC
GO
