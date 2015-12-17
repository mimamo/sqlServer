USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_CpnyID]    Script Date: 12/16/2015 15:55:34 ******/
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
