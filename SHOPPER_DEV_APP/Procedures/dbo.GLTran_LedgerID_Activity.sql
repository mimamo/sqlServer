USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_LedgerID_Activity]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_LedgerID_Activity    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLTran_LedgerID_Activity] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from GLTran
           where LedgerID             =  @parm1
             and Fiscyr >= @parm2
           order by LedgerID, Fiscyr, Acct, Sub
GO
