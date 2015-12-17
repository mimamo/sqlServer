USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_COPostProcess]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_COPostProcess]
	@ri_id		smallint
as

	update 	POReqHdr
	set	COPrinted = 1
	from	POPrintQueue q, POReqHdr h
	where	q.ReqNbr = h.ReqNbr
	  and	q.ReqCntr = h.ReqCntr
	  and	q.RI_ID = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
