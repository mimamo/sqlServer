USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServDetail_CallID_FRLineNbr]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--:message Creating procedure ..

CREATE PROCEDURE
	[dbo].[smServDetail_CallID_FRLineNbr]
		@parm1	varchar(10)
		,@parm2 smallint
		,@parm3beg	smallint
		,@parm3end 	smallint
AS
	SELECT
		*
	FROM
		smServDetail

	WHERE
		ServiceCallID = @parm1
			AND
		FlatRateLineNbr = @parm2
			AND
		LineNbr BETWEEN @parm3beg AND @parm3end
			AND
		BillingType = 'F'
	 ORDER BY
	 	ServiceCallID
	 	,FlatRateLineNbr, LineNbr
GO
