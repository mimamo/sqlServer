USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipLine_Count]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SOShipLine_Count]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	count(*)
	from	SOShipLine
	Where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
