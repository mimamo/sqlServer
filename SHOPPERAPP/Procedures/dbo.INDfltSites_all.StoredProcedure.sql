USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[INDfltSites_all]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INDfltSites_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM INDfltSites (NOLOCK)
	WHERE InvtID LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY InvtID,
	   CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
