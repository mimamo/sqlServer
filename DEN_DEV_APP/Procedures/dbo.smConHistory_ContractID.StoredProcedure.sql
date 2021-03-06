USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConHistory_ContractID]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConHistory_ContractID]
		@parm1	varchar(10)
		,@parm2	smallint
		,@parm3	smallint
		,@parm4	smallint
		,@parm5	smallint
AS
	SELECT
		*
	FROM
		smConHistory
 	WHERE
		ContractId = @parm1
			AND
		HistYear  BETWEEN @parm2 AND @parm3
			AND
		HistMonth BETWEEN @parm4 AND @parm5
	ORDER BY
		ContractID
		,HistYear
		,HistMonth

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
