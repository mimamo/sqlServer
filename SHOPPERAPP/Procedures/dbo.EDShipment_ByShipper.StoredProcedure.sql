USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ByShipper]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_ByShipper] @CpnyId varchar(10), @ShipperId varchar(10) As
Select * From EDShipment Where BOLNbr = (Select BOLNbr From EDShipTicket Where CpnyId = @CpnyID
And ShipperId = @ShipperId)
GO
