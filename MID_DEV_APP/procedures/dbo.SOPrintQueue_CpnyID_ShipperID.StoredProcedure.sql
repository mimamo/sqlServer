USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintQueue_CpnyID_ShipperID]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintQueue_CpnyID_ShipperID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM SOPrintQueue
	WHERE CpnyID LIKE @parm1
	   AND ShipperID LIKE @parm2
	ORDER BY CpnyID,
	   ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
