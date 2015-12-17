USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_Shipper_Cpny]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_Shipper_Cpny] @ShipperId varchar(15), @CpnyId varchar(10) AS
 Select * from EDShipTicket where ShipperId = @ShipperId and CpnyId = @CpnyId order by BolNbr,CpnyId,ShipperId
GO
