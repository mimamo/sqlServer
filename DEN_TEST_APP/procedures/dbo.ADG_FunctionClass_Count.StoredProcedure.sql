USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_FunctionClass_Count]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_FunctionClass_Count]
	@cpnyid			varchar (10),
	@sotypeid		varchar (4),
	@currfunction		varchar (8),
	@currclass		varchar (4)
as
	-- Determine the Seq for the current function and class.
	select	count(*)
	from 	sostep
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	functionid = @currfunction
	  and	functionclass = @currclass

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
