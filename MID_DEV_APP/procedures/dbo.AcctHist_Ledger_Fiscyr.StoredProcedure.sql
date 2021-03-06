USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Ledger_Fiscyr]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Ledger_Fiscyr    Script Date: 1/11/99 12:45:04 PM ******/
Create Proc [dbo].[AcctHist_Ledger_Fiscyr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from AcctHist
           where LedgerID like @parm1
             and Fiscyr = @parm2
           order by LedgerID, FiscYr, Acct, Sub
GO
