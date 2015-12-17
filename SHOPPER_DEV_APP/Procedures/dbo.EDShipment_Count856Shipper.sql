USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Count856Shipper]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_Count856Shipper] @BOLNbr varchar(20)As
Select Count(*) From EDShipTicket A, SOShipHeader B Where A.BOLNbr = @BOLNbr And A.CpnyId = B.CpnyId
And A.ShipperId = B.ShipperId And B.EDI856 = 1
GO
