USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Close_Cust_Doc_StmtCycle2]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Close_Cust_Doc_StmtCycle2    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[Close_Cust_Doc_StmtCycle2] @parm1 smalldatetime, @parm2 varchar(10) As
        UPDATE ARDoc SET ARDoc.StmtDate = @parm1,
        ARDoc.StmtBal = ARDoc.DocBal,
        ARDoc.CuryStmtBal = ARDoc.CuryDocBal
        WHERE ARDoc.CustId = @parm2
        AND ARDoc.Rlsed = 1
        AND ARDoc.StmtDate = ''
GO
