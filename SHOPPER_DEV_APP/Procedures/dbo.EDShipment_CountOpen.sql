USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_CountOpen]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_CountOpen] @BolNbr varchar(20) As
Select Count(*) From EDShipTicket A, SOShipHeader B
Where A.BOLNbr = @BOLNbr And A.CpnyId = B.CpnyId And A.ShipperID = B.ShipperId And B.Status <> 'C'
GO
