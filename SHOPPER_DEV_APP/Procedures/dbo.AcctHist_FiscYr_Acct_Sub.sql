USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_FiscYr_Acct_Sub]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_FiscYr_Acct_Sub    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_FiscYr_Acct_Sub] @parm1 varchar ( 4), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
       Select * from AcctHist
           where FiscYr like @parm1
             and Acct   like @parm2
             and Sub    like @parm3
             and LedgerID like @parm4
           order by FiscYr, Acct, Sub, LedgerID
GO
