USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_ShipperId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_ShipperId]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDContainerDet
 WHERE ShipperId LIKE @parm1
 ORDER BY ShipperId
GO
