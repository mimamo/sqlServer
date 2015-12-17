USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_Cpnyid_Shipperid]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSOShipLine_Cpnyid_Shipperid]
 @parm1 varchar( 10 ),
 @parm2 varchar( 15 )
 AS
 SELECT *
 FROM SOShipLine
 WHERE CpnyID LIKE @parm1
    AND ShipperID LIKE @parm2
 ORDER BY CpnyID, ShipperID
GO
