USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr2_Adj]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_BatNbr2_Adj] @parm1 varchar ( 10) as
    Select * from INTran
        where INTran.BatNbr = @parm1
        and INTran.Rlsed = 0
        order by BatNbr DESC, InvtId DESC, SiteId DESC, Qty DESC
GO
