USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_GetViaSite]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_GetViaSite] @CpnyId varchar(10), @ShipperId varchar(15) As
Select ShipViaId,SiteId From SOShipHeader Where CpnyId = @CpnyId And ShipperId = @ShipperId
GO
