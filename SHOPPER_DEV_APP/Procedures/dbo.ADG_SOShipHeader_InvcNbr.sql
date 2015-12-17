USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_InvcNbr]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_InvcNbr]
	@CpnyID varchar(10),
	@InvcNbr varchar(10)
AS
	SELECT *
	FROM SOShipHeader
	WHERE CpnyID = @CpnyID AND
		InvcNbr LIKE @InvcNbr
	ORDER BY InvcNbr, CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
