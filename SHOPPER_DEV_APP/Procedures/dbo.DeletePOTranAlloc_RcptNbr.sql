USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTranAlloc_RcptNbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTranAlloc_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTranAlloc_RcptNbr] @parm1 varchar ( 10) As
Delete from POTranAlloc Where RcptNbr = @parm1
GO
