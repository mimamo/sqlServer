USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipMark_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipMark_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM SOShipMark
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	ORDER BY CpnyID,
	   ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
