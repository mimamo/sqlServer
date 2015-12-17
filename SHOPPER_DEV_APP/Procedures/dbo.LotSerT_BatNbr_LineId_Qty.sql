USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_BatNbr_LineId_Qty]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_LineId_Qty    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr_LineId_Qty    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_BatNbr_LineId_Qty] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar ( 30), @parm4 int as
Select TranSrc, BatNbr, INTranLineId, sum(Qty) from LotSerT
    where     TranSrc = @parm1 and
              BatNbr  = @parm2 and
              KitID = @parm3 and
	      INTranLineId  = @parm4
	Group By  TranSrc, BatNbr, KitID, INTranLineId
GO
