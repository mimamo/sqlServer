USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOSplitDefaults_Copy]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOSplitDefaults_Copy]
	@cpnyid	varchar(10),
	@ordnbr	varchar(15)
as
	select	CreditPct,
		NoteID,
		SlsperID
	from	SOSplitDefaults
	where	CpnyID = @cpnyid
	  and	OrdNbr = @ordnbr
	order by SlsperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
