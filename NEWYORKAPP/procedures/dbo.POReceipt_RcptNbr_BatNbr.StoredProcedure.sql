USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_RcptNbr_BatNbr]    Script Date: 12/21/2015 16:01:12 ******/
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
