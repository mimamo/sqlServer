USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smMarkBreaks_MarkupId]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMarkBreaks_MarkupId]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smMarkBreaks
	WHERE
		MarkupBreakId = @parm1
			AND
		LineNbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		MarkupBreakId
		,MarkupBreakFrom
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
