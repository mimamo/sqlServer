USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_SingleShipper]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_SingleShipper] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From SOShipHeader Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
