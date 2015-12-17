USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_CanclShStatus]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_CanclShStatus]
	@CpnyID varchar( 10 ),
	@ShipperID varchar( 15 ),
	@Status varchar( 1 )

AS
	UPDATE 	SOShipHeader
	SET 	Status = @Status
	WHERE 	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
