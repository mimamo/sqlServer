USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_SelectReprint]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_SelectReprint] As
Select BOLNbr From EDShipment Where BOLState = 'S' And ShipStatus = 'C' And SendASN = 1
GO
