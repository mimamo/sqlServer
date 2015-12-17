USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTick_FindOld]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTick_FindOld] @ShipperID varchar(15), @BolNbr varchar(20), @CpnyID varchar(10) AS
select * from EDShipTicket where ShipperID = @ShipperID and bolnbr <> @BolNbr and CpnyID = @CpnyID
GO
