USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetSkipToFunction]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GetSkipToFunction]
	@cpnyid			varchar(10),
	@sotypeid		varchar(4),
	@skipto			varchar(4)
as
	select	functionid,
		functionclass
	from	sostep
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	seq >= @skipto
	  and	status <> 'D'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
