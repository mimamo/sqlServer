USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_CountContainers]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_CountContainers] @BOLNbr varchar(20) As
Select Count(*) From EDShipTicket A Join EDContainer B On A.ShipperId = B.ShipperId And A.CpnyId = B.CpnyId
Where A.BOLNbr = @BOLNbr
GO
