USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Cpny_Ledger_Fiscyr]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Cpny_Ledger_Fiscyr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_Cpny_Ledger_Fiscyr] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 4) as
       Select * from AcctHist
           where CpnyID like @parm1
             and LedgerID like @parm2
             and Fiscyr = @parm3
           order by CpnyID, LedgerID, FiscYr, Acct, Sub
GO
