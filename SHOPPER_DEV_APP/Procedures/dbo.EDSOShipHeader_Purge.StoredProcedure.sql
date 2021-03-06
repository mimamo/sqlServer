USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_Purge]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipHeader_Purge] As
Delete From EDSOShipHeader Where Not Exists (Select * From SOShipHeader Where EDSOShipHeader.CpnyId =
SOShipHeader.CpnyId And EDSOShipHeader.ShipperId = SOShipHeader.ShipperId)
Delete From EDContainer Where Not Exists (Select * From SOShipHeader Where EDContainer.CpnyId =
SOShipHeader.CpnyId And EDContainer.ShipperId = SOShipHeader.ShipperId)
Delete From EDContainerDet Where Not Exists (Select * From SOShipHeader Where EDContainerDet.CpnyId =
SOShipHeader.CpnyId And EDContainerDet.ShipperId = SOShipHeader.ShipperId)
Delete From EDShipTicket Where Not Exists (Select * From SOShipHeader Where EDShipTicket.CpnyId =
SOShipHeader.CpnyId And EDShipTicket.ShipperId = SOShipHeader.ShipperId)
Delete From EDShipment Where Not Exists (Select * From EDShipTicket Where EDShipment.BOLNbr =
EDShipTicket.BOLNbr)
GO
