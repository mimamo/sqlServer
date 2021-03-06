USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetNextSeqDescr]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GetNextSeqDescr]
	@cpnyid			varchar (10),
	@sotypeid		varchar (4),
	@nextfunction		varchar (8),
	@nextclass		varchar (4)
as

	-- Determine the Seq for the previously-planned NextFunction and NextClass.
	select	seq,
		descr
	from 	sostep
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	functionid = @nextfunction
	  and	functionclass = @nextclass

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
