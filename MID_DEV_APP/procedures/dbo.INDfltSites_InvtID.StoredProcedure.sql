USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INDfltSites_InvtID]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INDfltSites_InvtID]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM INDfltSites
	WHERE InvtID LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY InvtID,
	   CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
