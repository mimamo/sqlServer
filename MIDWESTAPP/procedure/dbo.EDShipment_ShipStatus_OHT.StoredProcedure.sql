USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ShipStatus_OHT]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_ShipStatus_OHT] AS
Select * from EDShipment where shipstatus in ('O','H','T')
GO
