USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_BatNbr_LineId]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_LineId    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_LineId    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_BatNbr_LineId] @parm1 varchar (2), @parm2 varchar ( 10), @parm3 varchar ( 30), @parm4 int as
    Select * from LotSerT where TranSrc = @parm1
                  and Batnbr = @parm2
                  and KitID = @parm3
                  and INTranLineId = @parm4
                  order by TranSrc,BatNbr,KitID,INTranLineId
GO
