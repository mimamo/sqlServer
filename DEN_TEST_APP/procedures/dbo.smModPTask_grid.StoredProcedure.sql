USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smModPTask_grid]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smModPTask_grid]
		@parm1	varchar(10)
		,@parm2	varchar(40)
		,@parm3	varchar(10)
AS
	SELECT
		*
	FROM
		smModPTask
		,smPMHeader
	WHERE
		smModPTask.Manuf = @parm1
			AND
		smModPTask.Model = @parm2
			AND
		smModPTask.PMCode LIKE @parm3
			AND
		smModPTask.PMCode = smPMHeader.PMType
 	ORDER BY
		smModPTask.Manuf
		,smModPTask.Model
		,smModPTask.PMCode
GO
