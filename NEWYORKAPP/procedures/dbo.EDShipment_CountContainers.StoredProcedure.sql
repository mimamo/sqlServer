USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_CountContainers]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_CountContainers] @BOLNbr varchar(20) As
Select Count(*) From EDShipTicket A Join EDContainer B On A.ShipperId = B.ShipperId And A.CpnyId = B.CpnyId
Where A.BOLNbr = @BOLNbr
GO
