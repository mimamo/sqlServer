USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_Open]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeader_Open]
	@CpnyID varchar(10),
	@ShipperID varchar(15)
AS
	SELECT 	*
	FROM 	SOShipHeader
	WHERE 	CpnyID LIKE @CpnyID
	  AND 	ShipperID LIKE @ShipperID
	  AND	Status = 'O'
	ORDER BY CpnyID,
	   ShipperID DESC

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
