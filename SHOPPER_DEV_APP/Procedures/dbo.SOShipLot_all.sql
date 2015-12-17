USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLot_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipLot_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 5 )
AS
	SELECT *
	FROM SOShipLot
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND LineRef LIKE @parm3
	   AND LotSerRef LIKE @parm4
	ORDER BY CpnyID,
	   ShipperID,
	   LineRef,
	   LotSerRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
