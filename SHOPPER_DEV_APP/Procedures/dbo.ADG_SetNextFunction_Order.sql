USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SetNextFunction_Order]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SetNextFunction_Order]
	@cpnyid			varchar(10),
	@ordnbr			varchar(15),
	@currfunction		varchar(8),
	@currclass		varchar(4)
as
	update	soheader
	set	nextfunctionid = @currfunction,
		nextfunctionclass = @currclass
	where	cpnyid = @cpnyid
	  and	ordnbr = @ordnbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
