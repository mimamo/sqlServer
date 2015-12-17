USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Specific]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Specific    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_Specific] @parm1 varchar(10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 4) as
       Select * from AcctHist
           where CpnyID = @parm1
             and Acct   = @parm2
             and Sub    = @parm3
             and LedgerID = @parm4
             and FiscYr = @parm5
GO
