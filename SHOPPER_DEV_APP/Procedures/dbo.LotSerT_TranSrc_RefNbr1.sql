USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_TranSrc_RefNbr1]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_RefNbr1    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_RefNbr1    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[LotSerT_TranSrc_RefNbr1] @parm1 varchar (2), @parm2 varchar (15), @parm3 varchar ( 30), @parm4 int as
    Select * from LotSerT where TranSrc = @parm1
                  and RefNbr = @parm2
                  and InvtId = @parm3
                  and INTranLineId = @parm4
                  order by BatNbr, InvtId
GO
