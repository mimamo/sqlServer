USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Trsl]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Trsl    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_Trsl] @parm1 varchar ( 10), @parm2beg varchar ( 10), @parm2end varchar ( 10), @parm3beg varchar ( 24), @parm3end varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 4) as
       Select * from AcctHist
           where CpnyID         = @parm1
             and Acct             between  @parm2beg and @parm2end
             and Sub              between  @parm3beg and @parm3end
             and LedgerId       = @parm4
             and FiscYr         = @parm5
             order by Acct,Sub,LedgerId, FiscYr
GO
