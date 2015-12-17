USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ViaCode]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_ViaCode]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDShipment
 WHERE ViaCode LIKE @parm1
 ORDER BY ViaCode
GO
