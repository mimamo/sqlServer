USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_StmtCycleId_AutoApply]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Customer_StmtCycleId_AutoApply    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Customer_StmtCycleId_AutoApply] @parm1 varchar ( 2) as
 Select * from Customer where StmtCycleId = @parm1
  order by StmtCycleId, CustId
GO
