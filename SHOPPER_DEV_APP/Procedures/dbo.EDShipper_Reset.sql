USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipper_Reset]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipper_Reset] @CpnyId varchar(10), @ShipperId varchar(15) As
-- Set the shipped qty to 0 and clear lotsernbr & whseloc on the remaining soshiplot lines
Update SOShipLot Set QtyShip = 0 Where CpnyId = @CpnyId And ShipperId = @ShipperId
-- Set the shipped qty to 0 and the lotsercntr to 1 on the soshipline records
Update SOShipLine Set QtyShip = 0 Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
