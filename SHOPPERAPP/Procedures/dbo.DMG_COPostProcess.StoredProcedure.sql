USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_COPostProcess]    Script Date: 12/21/2015 16:13:06 ******/
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
