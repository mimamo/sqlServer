USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipVia_ShipViaID_SCAC]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipVia_ShipViaID_SCAC] @EDIViaCode varchar(20) AS
Select ShipViaID,SCAC From ShipVia
Where EDIViaCode = @EDIViaCode
GO
