USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_QtyShipUpd]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLot_QtyShipUpd] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5), @QtyShip float As
Update SOShipLot Set QtyShip = @QtyShip Where CpnyId = @CpnyId And ShipperId = @ShipperId And LineRef = @LineRef
GO
