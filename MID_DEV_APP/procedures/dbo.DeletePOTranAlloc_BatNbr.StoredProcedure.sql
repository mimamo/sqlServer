USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeletePOTranAlloc_BatNbr]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeletePOTranAlloc_BatNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[DeletePOTranAlloc_BatNbr]
	@BatNbr varchar (10)
As
	Delete from POTranAlloc
	from POTranAlloc
	join POTran on POTran.RcptNbr = POTranAlloc.RcptNbr
	Where POTran.BatNbr = @BatNbr
GO
