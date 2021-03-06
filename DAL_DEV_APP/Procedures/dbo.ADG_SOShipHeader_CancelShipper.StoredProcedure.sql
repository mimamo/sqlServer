USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_CancelShipper]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_CancelShipper]
	@CpnyID varchar( 10 ),
	@ShipperID varchar( 15 ),
	@NextFunctionID varchar( 8 ),
	@NextFunctionClass varchar( 4 ),
	@Cancelled integer
AS
	UPDATE 	SOShipHeader
	SET 	NextFunctionID = @NextFunctionID,
		NextFunctionClass = @NextFunctionClass,
		Cancelled = @Cancelled,
		DateCancelled = GETDATE()
	WHERE 	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
