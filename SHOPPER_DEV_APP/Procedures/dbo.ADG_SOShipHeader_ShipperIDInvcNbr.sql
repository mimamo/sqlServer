USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_ShipperIDInvcNbr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_ShipperIDInvcNbr]
	@CpnyID varchar(10),
	@InvcNbr varchar(10)
AS
	SELECT ShipperID
	FROM SOShipHeader
	WHERE CpnyID = @CpnyID AND
		InvcNbr = @InvcNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
