USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTranAlloc_RcptNbr]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTranAlloc_RcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTranAlloc_RcptNbr] @parm1 varchar ( 10) As
Delete from POTranAlloc Where RcptNbr = @parm1
GO
