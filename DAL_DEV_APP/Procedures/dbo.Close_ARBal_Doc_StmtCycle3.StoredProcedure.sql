USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Close_ARBal_Doc_StmtCycle3]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Close_ARBal_Doc_StmtCycle3    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[Close_ARBal_Doc_StmtCycle3] @parm1 smalldatetime, @parm2 varchar ( 15), @parm3 varchar ( 10), @parm4 varchar ( 6) As
        UPDATE ARDoc SET ARDoc.StmtDate = @parm1,
        ARDoc.StmtBal = ARDoc.DocBal,
        ARDoc.CuryStmtBal = ARDoc.CuryDocBal
        WHERE ARDoc.CustId = @parm2
        AND ARDoc.CpnyID = @parm3
        AND ARDoc.Rlsed = 1
        AND ARDoc.StmtDate = ''
        AND ARDoc.PerPost <= @parm4
GO
