USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcct_Specific]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryAcct_Specific    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[CuryAcct_Specific] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 24), @parm4 varchar ( 4) As
       Select * from CuryAcct
       where Acct     = @parm1
       and   Sub      = @parm2
       and   LedgerID = @parm3
       and   FiscYr   = @parm4
GO
