USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_CpnyID_EXE]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_CpnyID_EXE]
		@parm1	varchar(1)
		,@parm2 varchar(10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
	WHERE
		ServiceCallCompleted LIKE @parm1
			AND
		CpnyID = @parm2
			AND
		ServiceCallId LIKE @parm3
	ORDER BY
		ServiceCallId
GO
