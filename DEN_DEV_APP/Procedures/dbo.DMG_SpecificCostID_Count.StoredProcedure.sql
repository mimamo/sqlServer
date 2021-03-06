USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SpecificCostID_Count]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[DMG_SpecificCostID_Count]
	@CpnyID	varchar(10),
	@ShipperID varchar(15),
	@LineRef varchar(5)
as
	select	count(distinct(SOShipLot.S4Future01))
	from	SOShipLot
	where	CpnyID like @CpnyID
	and	ShipperID like @ShipperID
	and	LineRef like @LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
