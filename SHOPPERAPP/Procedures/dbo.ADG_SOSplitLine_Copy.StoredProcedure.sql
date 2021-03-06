USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSplitLine_Copy]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSplitLine_Copy]
	@cpnyid		varchar(10),
	@ordnbr		varchar(15),
	@lineref	varchar(5)
as
	select	CreditPct,
		NoteID,
		SlsperID
	from	SOSplitLine
	where	CpnyID = @cpnyid
	  and	OrdNbr = @ordnbr
	  and	LineRef = @lineref
	order by SlsperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
