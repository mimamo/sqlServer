USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOReceipt_RcptNbr]    Script Date: 12/21/2015 16:00:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOReceipt_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOReceipt_RcptNbr] @parm1 varchar ( 10) As
Delete poreceipt from POReceipt Where RcptNbr = @parm1
GO
