USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_Status]    Script Date: 12/21/2015 16:01:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_Status]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM POReqDet
	WHERE Status LIKE @parm1
	ORDER BY Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
