USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_UpdateInvoice]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_UpdateInvoice]
	@CpnyID 	varchar( 10 ),
	@ShipperID 	varchar( 15 ),
	@InvcNbr	varchar( 15 ) = null,
	@InvcDate	smalldatetime = null,
	@PerPost	varchar( 6 ) = null
AS
	UPDATE 	SOShipHeader
	SET 	InvcNbr = coalesce(@InvcNbr, InvcNbr), InvcDate = coalesce(@InvcDate, InvcDate), PerPost = coalesce(@PerPost, PerPost)
	WHERE 	CpnyID = @CpnyID
	  AND	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
