USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_ViaIdSCACCarrier]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipVia_ViaIdSCACCarrier] @ShipViaId varchar(15) As
Select ShipViaId, SCAC, CarrierId From ShipVia Where ShipViaId = @ShipViaId
GO
