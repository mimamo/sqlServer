USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_PONbr]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_PONbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReqHdr
	WHERE PONbr LIKE @parm1
	ORDER BY PONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
