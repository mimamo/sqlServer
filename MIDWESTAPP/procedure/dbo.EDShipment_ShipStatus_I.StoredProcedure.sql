USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ShipStatus_I]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_ShipStatus_I] AS
Select * from EDShipment where shipstatus = 'I'
GO
