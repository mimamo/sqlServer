USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_ResetLastEDIDate]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_ResetLastEDIDate] @CpnyId varchar(10), @ShipperId varchar(15) As
Update EDSOShipHeader Set LastEDIDate = '01/01/1900' Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
