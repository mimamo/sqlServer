USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOReceipt_BatNbr]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOReceipt_BatNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOReceipt_BatNbr] @parm1 varchar ( 10) As
   Delete poreceipt from POReceipt Where BatNbr = @parm1
GO
