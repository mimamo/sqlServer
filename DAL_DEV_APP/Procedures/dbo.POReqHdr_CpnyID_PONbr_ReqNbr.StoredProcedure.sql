USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_CpnyID_PONbr_ReqNbr]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_CpnyID_PONbr_ReqNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM POReqHdr
	WHERE CpnyID = @parm1
		AND POnbr = @parm2
	   	AND ReqNbr LIKE @Parm3

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
