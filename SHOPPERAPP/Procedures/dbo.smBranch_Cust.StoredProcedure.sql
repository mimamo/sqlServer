USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smBranch_Cust]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smBranch_Cust]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smBranch
	WHERE
		BranchId LIKE @parm1
	ORDER BY
		BranchId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
