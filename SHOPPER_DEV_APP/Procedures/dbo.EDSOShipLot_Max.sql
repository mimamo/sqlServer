USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_Max]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipLot_Max] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select Max(LotSerRef) From SOShipLot Where Cpnyid = @CpnyId And ShipperId = @ShipperId And
LineRef = @LineRef
GO
