USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_ShipViaID_SCAC]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_ShipViaID_SCAC] @EDIViaCode varchar(20) AS
Select ShipViaID,SCAC From ShipVia
Where EDIViaCode = @EDIViaCode
GO
