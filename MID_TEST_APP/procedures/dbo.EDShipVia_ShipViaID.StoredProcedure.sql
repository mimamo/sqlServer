USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_ShipViaID]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_ShipViaID] @SCAC varchar(5) AS
Select ShipViaID From ShipVia
Where SCAC = @SCAC
GO
