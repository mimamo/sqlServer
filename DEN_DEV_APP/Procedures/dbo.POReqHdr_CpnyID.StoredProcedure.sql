USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_CpnyID]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_CpnyID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReqHdr
	WHERE CpnyID LIKE @parm1
	ORDER BY CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
