USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipSched_all]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipSched_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 15 ),
	@parm5 varchar( 5 ),
	@parm6 varchar( 5 )
AS
	SELECT *
	FROM SOShipSched
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND ShipperLineRef LIKE @parm3
	   AND OrdNbr LIKE @parm4
	   AND OrdLineRef LIKE @parm5
	   AND OrdSchedRef LIKE @parm6
	ORDER BY CpnyID,
	   ShipperID,
	   ShipperLineRef,
	   OrdNbr,
	   OrdLineRef,
	   OrdSchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
