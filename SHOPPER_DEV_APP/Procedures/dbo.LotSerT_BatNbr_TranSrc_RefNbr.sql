USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_BatNbr_TranSrc_RefNbr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_TranSrc_RefNbr    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_TranSrc_RefNbr    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_BatNbr_TranSrc_RefNbr] @parm1 varchar ( 10), @parm2 varchar (2), @parm3 varchar (15), @parm4 varchar ( 30), @parm5 int as
    Select * from LotSerT where Batnbr = @parm1
                  and TranSrc = @parm2
                  and RefNbr = @parm3
                  and InvtId = @parm4
                  and INTranLineId = @parm5
                  order by BatNbr, InvtId
GO
