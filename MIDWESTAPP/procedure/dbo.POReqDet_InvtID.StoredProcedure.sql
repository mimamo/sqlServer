USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_InvtID]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_InvtID]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM POReqDet
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
