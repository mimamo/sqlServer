USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_BolNumber]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_BolNumber] @CpnyID varchar(10), @ShipperID varchar(15) AS
Select BOLNBR From EDShipTicket
Where CpnyId = @CpnyID
And ShipperId = @ShipperID
GO
