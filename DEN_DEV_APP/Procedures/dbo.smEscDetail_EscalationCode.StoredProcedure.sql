USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEscDetail_EscalationCode]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEscDetail_EscalationCode]
		@parm1 	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smEscDetail
	WHERE
		EscalationCode = @parm1
			AND
		EscYear BETWEEN @parm2beg AND @parm2end
	ORDER BY
		EscalationCode
		,EscYear

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
