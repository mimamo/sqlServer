USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_SCAC]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_SCAC] @ShipViaId varchar(10) AS
Select SCAC From ShipVia
Where ShipViaID = @ShipViaId
GO
