USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_StepAndReset]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDShipment_StepAndReset] AS
Select * From EDShipment Where BOLNbr In (Select Distinct(EDShipTicket.BOLNbr) From EDShipTicket,SOShipHeader Where EDShipTicket.ShipperId = SOShipHeader.ShipperId And EDShipTicket.CpnyId = SOShipHeader.CpnyId And SOShipHeader.NextFunctionId = '5040200')
Union
Select * From EDShipment Where ShipStatus = 'C' And BOLState = 'S' And SendASN = 1
GO
