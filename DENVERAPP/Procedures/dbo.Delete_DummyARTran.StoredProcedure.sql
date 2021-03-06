USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_DummyARTran]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_DummyARTran    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[Delete_DummyARTran] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    Delete artran from ARTran where
    BatNbr = @parm1
    and DrCr = 'U'
    and CustId = @parm2
    and (TranType = @parm3
    or TranType = "SB")
    and RefNbr = @parm4
GO
