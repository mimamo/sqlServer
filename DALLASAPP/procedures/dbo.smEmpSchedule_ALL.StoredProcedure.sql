USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpSchedule_ALL]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEmpSchedule_ALL]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end	smallint
AS
	SELECT
		*
	FROM
		smEmpSchedule
	WHERE
		EmpID = @parm1
			AND
		LineNbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		EmpID,
		StartDate
GO
