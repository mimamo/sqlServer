USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_RcptNbr_BatNbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_RcptNbr_BatNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_RcptNbr_BatNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) As
Select * From POReceipt
Where POReceipt.BatNbr <> ' ' and POReceipt.BatNbr = @parm1 And POReceipt.RcptNbr LIKE @parm2
Order By POReceipt.RcptNbr
GO
