USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARStmt_All]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARStmt_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARStmt_All] @parm1 varchar ( 2) as
    Select * from ARStmt where StmtCycleId like @parm1 order by StmtCycleId
GO
