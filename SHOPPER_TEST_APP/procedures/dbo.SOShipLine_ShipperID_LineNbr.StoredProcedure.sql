USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLine_ShipperID_LineNbr]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipLine_ShipperID_LineNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 smallint,
	@parm4 smallint
AS
	SELECT *
	FROM SOShipLine
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND LineNbr between @parm3 and @parm4
	ORDER BY CpnyID,
	   ShipperID,
	   LineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
