USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POTran_Receipts]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POTran_Receipts]  (
	@PONbr 		VARCHAR(10),
	@POLineRef	VARCHAR(5),
	@RcptNbr	VARCHAR(10)

)
AS

	Select 	POTran.*
	from 	POTran, POReceipt
	where 	POTran.PONbr = @PONbr
	  and	POTran.POLineRef Like @POLineRef
	  and	POTran.RcptNbr Like @RcptNbr
	  and	POTran.RcptNbr = POReceipt.RcptNbr
	  and 	POTran.TranType = 'R'
	  and	POReceipt.Rlsed = 1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
