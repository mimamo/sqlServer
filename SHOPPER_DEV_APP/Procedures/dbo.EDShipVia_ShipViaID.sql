USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_ShipViaID]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_ShipViaID] @SCAC varchar(5) AS
Select ShipViaID From ShipVia
Where SCAC = @SCAC
GO
