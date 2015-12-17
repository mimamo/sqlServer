USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POReqDet_Delete]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POReqDet_Delete]
	@ReqNbr	 varchar(10),
	@ReqCntr varchar(2)
AS
	DELETE	FROM POReqDet
	WHERE	ReqNbr LIKE @ReqNbr AND
		ReqCntr LIKE @ReqCntr AND
		S4Future09 = 0

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
