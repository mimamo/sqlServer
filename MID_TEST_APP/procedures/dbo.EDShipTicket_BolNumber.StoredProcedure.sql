USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_BolNumber]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_BolNumber] @CpnyID varchar(10), @ShipperID varchar(15) AS
Select BOLNBR From EDShipTicket
Where CpnyId = @CpnyID
And ShipperId = @ShipperID
GO
