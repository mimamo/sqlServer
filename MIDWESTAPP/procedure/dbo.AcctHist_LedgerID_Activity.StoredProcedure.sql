USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_LedgerID_Activity]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_LedgerID_Activity    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_LedgerID_Activity] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from AcctHist
           where LedgerID = @parm1
             and FiscYr >= @parm2
             order by LedgerID, FiscYr, Acct, Sub
GO
