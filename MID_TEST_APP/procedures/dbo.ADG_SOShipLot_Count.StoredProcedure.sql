USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipLot_Count]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipLot_Count]
	@CpnyID 		varchar(10),
	@ShipperID 		varchar(15),
	@LineRef 		varchar(5)
AS

	SELECT 	count(*)
	FROM 	SOShipLot
	WHERE 	SOShipLot.CpnyID = @CpnyID
	  AND	SOShipLot.ShipperID LIKE @ShipperID
	  AND	SOShipLot.LineRef LIKE @LineRef
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
