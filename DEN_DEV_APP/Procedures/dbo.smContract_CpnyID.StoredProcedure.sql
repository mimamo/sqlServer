USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_CpnyID]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_CpnyID]
		@parm1 	varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smContract
	WHERE
		CpnyID = @Parm1
	AND
		ContractId LIKE @parm2
	ORDER BY
		ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
