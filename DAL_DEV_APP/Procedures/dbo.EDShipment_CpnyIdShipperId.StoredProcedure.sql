USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_CpnyIdShipperId]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_CpnyIdShipperId] @CpnyId varchar(10), @ShipperId varchar(10) As
Select * From EDShipment Where BOLNbr = (Select BOLNbr From EDShipTicket Where
CpnyId = @CpnyId And ShipperId = @ShipperId)
GO
