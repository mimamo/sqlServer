USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POReceipt_Receipts]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POReceipt_Receipts](
	@PONbr 		VARCHAR(10)

)
AS
	Select distinct r.*
	from POReceipts r
	inner join potran t on t.rcptnbr = r.rcptnbr
	where t.PONbr = @PONbr and r.RcptType = 'R'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
