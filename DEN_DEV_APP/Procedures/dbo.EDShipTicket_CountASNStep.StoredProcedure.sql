USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_CountASNStep]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipTicket_CountASNStep] @BOLNbr varchar(20) As
Select Count(*) From EDShipTicket A, SOShipHeader B Where A.CpnyId = B.CpnyId And A.ShipperId = B.ShipperId
And A.BOLNbr = @BOLNBr And B.NextFunctionId = '5040200'
GO
