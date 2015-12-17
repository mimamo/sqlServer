USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_Update_BOL]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_Update_BOL] @BolNbr varchar(20), @CpnyID varchar(10), @ShipperID varchar(15) AS
Update EDShipTicket
Set BOLNbr = @BolNbr
Where CpnyId = @CpnyID
And ShipperId = @ShipperID
GO
