USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POPostProcess]    Script Date: 12/21/2015 14:34:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_POPostProcess]
	@ri_id		smallint
as

	update 	POReqHdr
	set	POPrinted = 1
	from	POPrintQueue q, POReqHdr h
	where	q.ReqNbr = h.ReqNbr
	  and	q.ReqCntr = h.ReqCntr
	  and	q.RI_ID = @ri_id

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
