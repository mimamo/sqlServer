USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_NegPos]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_BatNbr_NegPos    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_BatNbr_NegPos    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_BatNbr_NegPos] @parm1 varchar ( 10) as
    Select * from INTran
        where INTran.BatNbr = @parm1
        and INTran.Rlsed = 0
        order by BatNbr, InvtId, LineId, LineNbr, Qty
GO
