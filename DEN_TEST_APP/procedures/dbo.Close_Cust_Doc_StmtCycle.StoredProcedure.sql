USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Close_Cust_Doc_StmtCycle]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Close_Cust_Doc_StmtCycle    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[Close_Cust_Doc_StmtCycle] @parm1 varchar(10) as
        UPDATE ARDoc SET ARDoc.StmtBal = ARDoc.DocBal,
        ARDoc.CuryStmtBal = ARDoc.CuryDocBal
        WHERE ARDoc.CustId = @parm1
        AND ARDoc.Rlsed = 1
        AND (ARDoc.StmtDate <> '' AND ARDoc.StmtBal <> 0)
GO
