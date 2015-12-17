USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_Count]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLot_Count] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select Count(*) From SOShipLot Where CpnyId = @CpnyId And ShipperId = @ShipperId And LineRef = @LineRef
GO
