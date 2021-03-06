USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smPMDetail_PMType]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smPMDetail_PMType]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smPMDetail
	WHERE
		PMType = @parm1
			AND
		LineNbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		PMType
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
