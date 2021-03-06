USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smAgeDetail_AgeCode]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smAgeDetail_AgeCode]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smAgeDetail
	WHERE
		AgeCode = @parm1
			AND
		AgeYear between @parm2beg and @parm2end
	ORDER BY
		AgeCode
		,AgeYear

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
