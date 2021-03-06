USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipLot_Delete]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipLot_Delete]
		@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5),
	@LotSerRef	varchar(5)
AS
	IF @CpnyID <> '%' AND @ShipperID <> '%'
		DELETE FROM SOShipLot
		WHERE	CpnyID = @CpnyID AND
			ShipperID = @ShipperID AND
			LineRef + '' LIKE @LineRef AND
			LotSerRef + '' LIKE @LotSerRef
	ELSE
		DELETE FROM SOShipLot
		WHERE	CpnyID LIKE @CpnyID AND
			ShipperID LIKE @ShipperID AND
			LineRef LIKE @LineRef AND
			LotSerRef LIKE @LotSerRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
