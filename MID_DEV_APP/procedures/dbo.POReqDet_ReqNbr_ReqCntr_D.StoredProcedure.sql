USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_ReqNbr_ReqCntr_D]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_ReqNbr_ReqCntr_D]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReqDet
	WHERE ReqNbr = @parm1
		ORDER BY ReqNbr, LineRef, ReqCntr Desc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
