USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Status_All]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_Status_All]
		@parm1	varchar(1)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smContract
	WHERE
		Status = @parm1
			AND
		ContractId LIKE @parm2
	ORDER BY
		Status
		,ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
