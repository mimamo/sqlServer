USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetEventType]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GetEventType]
	@cpnyid			varchar (10),
	@sotypeid		varchar (4),
	@currfunction		varchar (8),
	@currclass		varchar (4)
as
	-- For the given function and class, return the eventtype.
	select  eventtype
	from    sostep
	where   cpnyid = @cpnyid
	  and   sotypeid = @sotypeid
	  and   functionid = @currfunction
          and	functionclass = @currclass
	  and   eventtype <> 'X'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
