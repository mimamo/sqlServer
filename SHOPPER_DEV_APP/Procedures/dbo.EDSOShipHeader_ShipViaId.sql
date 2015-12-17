USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_ShipViaId]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_ShipViaId] @CpnyId varchar(10), @ShipperId varchar(15) As
Select CpnyId, ShipperId, ShipViaId From SOShipHeader Where CpnyId = @CpnyId And ShipperId = @ShipperId And
Cancelled = 0
GO
