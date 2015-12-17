USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_set_Trantype]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[ARTran_set_Trantype] @parm1 varchar (10), @parm2 varchar (15), @parm3 varchar (10) as
        UPDATE ARTran SET ARTran.TranType = "VT"
        WHERE ARTran.BatNbr = @parm1
        AND ARTran.Custid = @parm2
        AND ARTran.TranType = "PA"
        AND ARTran.RefNbr = @parm3
GO
