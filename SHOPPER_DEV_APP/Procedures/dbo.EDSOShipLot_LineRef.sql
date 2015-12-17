USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLot_LineRef]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOShipLot_LineRef]
 @parm1 varchar( 10 ),
 @parm2 varchar( 10 ),
 @parm3 varchar( 5 )
AS
 SELECT *
 FROM SOShipLot
 WHERE CpnyID LIKE @parm1
    AND ShipperID LIKE @parm2
    AND LineRef LIKE @parm3
 ORDER BY CpnyID,
    ShipperID,
    LineRef
GO
