USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[VP_ADG_ShipRegister]    Script Date: 12/21/2015 16:00:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VP_ADG_ShipRegister]

 AS

	SELECT 	CpnyID, InvcNbr, OrdNbr, 
		ShipperID, ShipRegisterID=IsNull(NullIf(ShipRegisterID,''),AccrShipRegisterID),
		ReportName = '', VoidType = ''
	FROM 	SOShipHeader 

	UNION

	SELECT 	CpnyID, InvcNbr, OrdNbr = '', 
		ShipperID = '', ShipRegisterID,
		ReportName, VoidType
	FROM 	SOVoidInvc
GO
