USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Close_ARBal_StmtCycle]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Close_ARBal_StmtCycle    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[Close_ARBal_StmtCycle] @parm1 smalldatetime, @parm2 varchar ( 15), @parm3 smalldatetime As
        UPDATE AR_Balances SET LastStmtDate = @parm1,
        LastStmtBegBal = LastStmtBal00,
        LastStmtBal00 = CurrBal,
        LastStmtBal01 = AgeBal01,
        LastStmtBal02 = AgeBal02,
        LastStmtBal03 = AgeBal03,
        LastStmtBal04 = AgeBal04
        WHERE CustID = @parm2
        AND LastStmtDate < @parm3
GO
