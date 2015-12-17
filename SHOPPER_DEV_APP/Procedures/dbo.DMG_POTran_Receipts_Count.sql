USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POTran_Receipts_Count]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POTran_Receipts_Count]  (
	@PONbr 		VARCHAR(10),
	@POLineRef	VARCHAR(5),
	@RcptNbr	VARCHAR(10)

)
AS

	Select 	Count(*)
	from 	POTran, POReceipt
	where 	POTran.PONbr = @PONbr
	  and	POTran.POLineRef Like @POLineRef
	  and	POTran.RcptNbr Like @RcptNbr
	  and	POTran.RcptNbr = POReceipt.RcptNbr
	  and 	POTran.TranType = 'R'
	  and	POReceipt.Rlsed = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
