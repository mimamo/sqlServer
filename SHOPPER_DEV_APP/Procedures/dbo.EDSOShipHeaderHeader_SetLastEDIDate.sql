USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeaderHeader_SetLastEDIDate]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeaderHeader_SetLastEDIDate] @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDSOShipHeader Set LastEDIDate = GetDate() Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
