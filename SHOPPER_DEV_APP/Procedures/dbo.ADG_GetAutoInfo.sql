USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetAutoInfo]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_GetAutoInfo]
	@cpnyid			varchar (10),
	@sotypeid		varchar (4),
	@currfunction		varchar (8),
	@currclass		varchar (4)
as
	declare	@currseq	varchar (4)

	-- Determine the Seq for the current function and class.
	select	@currseq = seq
	from 	sostep
	where	cpnyid = @cpnyid
	  and	sotypeid = @sotypeid
	  and	functionid = @currfunction
	  and	functionclass = @currclass

	-- Get the order step and return the auto-run information.
	select  auto,
		autopgmid,
		autopgmclass,
		autoproc,
		creditchk,
		functionclass,
		functionid,
		prompt,
		rptprog,
		skipto,
		noteson
	from    sostep
	where   cpnyid = @cpnyid
	  and   sotypeid = @sotypeid
	  and   seq >= @currseq
	  and   status <> 'D'
	order by
		seq

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
