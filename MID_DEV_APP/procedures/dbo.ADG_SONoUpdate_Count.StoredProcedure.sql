USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SONoUpdate_Count]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SONoUpdate_Count]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	count(*)
	from	SONoUpdate
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
