USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Close]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_Close] @BOLNbr varchar(20) As
Update EDShipment Set ShipStatus = 'C', BOLState = 'S', SendASN = 0 Where BOLNbr = @BOLNbr
GO
