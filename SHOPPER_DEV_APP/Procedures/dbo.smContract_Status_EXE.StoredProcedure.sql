USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Status_EXE]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_Status_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smContract
	WHERE
		ContractId LIKE @parm1
			AND
		Status = 'A'
	ORDER BY
		ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
