USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARBalance_StmtDate]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARBalance_StmtDate    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARBalance_StmtDate] @parm1 varchar ( 15), @parm2 smalldatetime as
 Select * from AR_Balances WHERE
        AR_Balances.CustId = @parm1
        and AR_Balances.lastStmtDate <= @parm2
        Order By CustId, CpnyID
GO
