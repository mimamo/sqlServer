USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTran_BatNbr_RcptNbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTran_BatNbr_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTran_BatNbr_RcptNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Delete potran from POTran Where BatNbr = @parm1
and RcptNbr = @parm2
GO
