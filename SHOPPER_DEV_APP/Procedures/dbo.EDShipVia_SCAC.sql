USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_SCAC]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_SCAC] @ShipViaId varchar(10) AS
Select SCAC From ShipVia
Where ShipViaID = @ShipViaId
GO
