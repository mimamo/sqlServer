USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_InvtId]    Script Date: 12/21/2015 13:35:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_BatNbr_InvtId    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_BatNbr_InvtId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_BatNbr_InvtId] @parm1 varchar ( 10), @parm2 varchar ( 30) as
    Select * from INTran where Batnbr = @parm1
                  and InvtId = @parm2
                  order by BatNbr, InvtId, Qty
GO
