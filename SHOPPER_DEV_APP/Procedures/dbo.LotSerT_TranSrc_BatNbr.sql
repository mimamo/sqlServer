USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_TranSrc_BatNbr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_BatNbr    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_BatNbr    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[LotSerT_TranSrc_BatNbr] @parm1 varchar (2), @parm2 varchar ( 10), @parm3 int, @parm4 varchar (25) as
    Select * from LotSerT where TranSrc = @parm1
                  and Batnbr = @parm2
                  and INTranLineId = @parm3
                  and LotSerNbr = @parm4
                  order by TranSrc, BatNbr, INTranLineId, LotSerNbr
GO
