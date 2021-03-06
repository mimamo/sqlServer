USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_OrdNbr_ShipViaID]    Script Date: 12/21/2015 15:49:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_OrdNbr_ShipViaID]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@ShipViaID varchar(15)
AS
	select	distinct ShipVia.*
	from	ShipVia
	join	SOSched on SOSched.CpnyID = ShipVia.CpnyID and SOSched.ShipViaID = ShipVia.ShipViaID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	ShipVia.ShipViaID like @ShipViaID
	order by ShipVia.CpnyID, ShipVia.ShipViaID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
