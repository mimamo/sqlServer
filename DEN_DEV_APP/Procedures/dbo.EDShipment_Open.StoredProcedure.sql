USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Open]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_Open] As
Select * From EDShipment Where ShipStatus = 'O'
GO
