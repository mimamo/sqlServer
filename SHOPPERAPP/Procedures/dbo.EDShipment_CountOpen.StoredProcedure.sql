USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_CountOpen]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_CountOpen] @BolNbr varchar(20) As
Select Count(*) From EDShipTicket A, SOShipHeader B
Where A.BOLNbr = @BOLNbr And A.CpnyId = B.CpnyId And A.ShipperID = B.ShipperId And B.Status <> 'C'
GO
