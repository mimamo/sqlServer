USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_LineRef]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipLine_LineRef] @CpnyId varchar(10), @ShipperId varchar(15), @LineRef varchar(5) As
Select * From SOShipLine Where CpnyID = @CpnyId And ShipperId = @ShipperId And LineRef Like @LineRef
Order By CpnyID, ShipperID, LineRef
GO
