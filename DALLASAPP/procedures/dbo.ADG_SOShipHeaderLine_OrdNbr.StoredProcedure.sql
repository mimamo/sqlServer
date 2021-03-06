USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeaderLine_OrdNbr]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipHeaderLine_OrdNbr]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS
	SELECT 	SOShipLine.*,
		SOShipHeader.ShipDateAct,
		SOShipHeader.ETADate,
		SOShipHeader.ShipCmplt,
		SOShipHeader.WeekendDelivery,
		SOShipHeader.ShipViaID,
		SOShipHeader.ShiptoID,
		SOShipHeader.ShipName,
		SOShipHeader.SiteID,
		SOShipHeader.ShipDatePlan
	FROM 	SOShipHeader
	  JOIN 	SOShipLine (NOLOCK) ON (SOShipHeader.ShipperID = SOShipLine.ShipperID)
		  AND (SOShipHeader.CpnyID = SOShipLine.CpnyID)
	WHERE 	SOShipHeader.CpnyID = @CpnyID AND
		SOShipHeader.OrdNbr LIKE @OrdNbr
	ORDER BY SOShipHeader.OrdNbr,  SOShipHeader.CustID, SOShipLine.InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
