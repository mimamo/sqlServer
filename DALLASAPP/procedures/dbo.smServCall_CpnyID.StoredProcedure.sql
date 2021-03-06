USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_CpnyID]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_CpnyID]
		@parm1	varchar(1)
		,@parm2 varchar(10)
		,@parm3 varchar(10)
AS
	SELECT *
	FROM
		smServCall
	WHERE
		ServiceCallCompleted = CONVERT(int,@parm1)
			AND
		CpnyID = @parm2
			AND
		ServiceCallId LIKE @parm3
	ORDER BY
		ServiceCallId
GO
