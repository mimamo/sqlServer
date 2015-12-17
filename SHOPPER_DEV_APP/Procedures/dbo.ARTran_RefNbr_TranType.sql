USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_RefNbr_TranType]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_RefNbr_TranType    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_RefNbr_TranType] @parm1 varchar ( 10), @parm2 varchar ( 2) as
    Select * from ARTran where ARTran.RefNbr = @parm1
        and ARTran.TranType = @parm2
        order by RefNbr, TranType, LineNbr
GO
