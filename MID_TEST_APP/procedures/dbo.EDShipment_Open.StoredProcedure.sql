USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Open]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_Open] As
Select * From EDShipment Where ShipStatus = 'O'
GO
