USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smMarkBreaks_MarkupID_Limit]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMarkBreaks_MarkupID_Limit]
		@parm1	varchar(10)
		,@parm2	float
AS
	SELECT
		*
	FROM
		smMarkBreaks
	WHERE
		MarkupBreakId = @parm1
			AND
		 MarkupBreakLimit >= @parm2
	ORDER BY
		MarkupBreakId
		,MarkupBreakLimit

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
