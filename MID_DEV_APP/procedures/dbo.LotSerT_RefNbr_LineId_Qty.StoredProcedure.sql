USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_RefNbr_LineId_Qty]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_RefNbr_LineId_Qty    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_RefNbr_LineId_Qty    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_RefNbr_LineId_Qty] @parm1 varchar ( 2), @parm2 varchar ( 15), @parm3 int as
Select TranSrc, RefNbr, INTranLineId, sum(Qty) from LotSerT
    where     TranSrc = @parm1 and
              RefNbr  = @parm2 and
              INTranLineId  = @parm3
	Group By  TranSrc, RefNbr, INTranLineId
GO
