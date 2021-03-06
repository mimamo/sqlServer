USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SetNextFunction_Shipper]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SetNextFunction_Shipper]
	@cpnyid			varchar(10),
	@shipperid		varchar(15),
	@currfunction		varchar(8),
	@currclass		varchar(4)
as
	update	soshipheader
	set	nextfunctionid = @currfunction,
		nextfunctionclass = @currclass
	where	cpnyid = @cpnyid
	  and	shipperid = @shipperid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
