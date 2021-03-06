USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPlan_CpnyID_SOShipperID_SOSh]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPlan_CpnyID_SOShipperID_SOSh]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOPlan
	WHERE CpnyID LIKE @parm1
	   AND SOShipperID LIKE @parm2
	   AND SOShipperLineRef LIKE @parm3
	ORDER BY CpnyID,
	   SOShipperID,
	   SOShipperLineRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
