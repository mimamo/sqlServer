USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ShipVia_Fetch]    Script Date: 12/21/2015 16:00:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ShipVia_Fetch]
	@CpnyID		varchar(10),
	@ShipViaID 	varchar(15)
as
	select	convert(smallint, S4Future11),	-- SatPickup
		convert(smallint, S4Future12),	-- SunPickup
		MoveOnDeliveryDays,		-- SatMove
		convert(smallint, S4Future10),	-- SunMove
		WeekendDelivery,		-- SatDelivery
		convert(smallint,S4Future09)	-- SunDelivery

	from	ShipVia
	where	CpnyID = @CpnyID
	  and	ShipViaID = @ShipViaID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
