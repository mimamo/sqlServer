USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Set_ShipStatus]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_Set_ShipStatus] @BolNbr varchar(20) AS
Update EDShipment set ShipStatus = 'R' where BOLNbr = @BolNbr
GO
