USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_ARTran_Bat_Ref]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_ARTran_Bat_Ref    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[Delete_ARTran_Bat_Ref] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    delete artran from ARTran
    where BatNbr = @parm1
    and CustId = @parm2
    and TranType = @parm3
    and RefNbr = @parm4
GO
