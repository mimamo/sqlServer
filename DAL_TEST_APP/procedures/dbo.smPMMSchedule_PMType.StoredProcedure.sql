USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smPMMSchedule_PMType]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smPMMSchedule_PMType]
		@parm1	varchar(10)
		,@parm2	varchar(10)
		,@parm3 varchar(40)
AS
	SELECT
		*
	FROM
		smPMMSchedule
	WHERE
		PMType LIKE @parm1
			AND
		ManufID LIKE @parm2
			AND
		ModelID LIKE @parm3
	ORDER BY
		PMType
		,ManufID
		,ModelID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
