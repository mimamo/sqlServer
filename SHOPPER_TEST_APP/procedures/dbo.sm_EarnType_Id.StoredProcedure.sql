USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_EarnType_Id]    Script Date: 12/21/2015 16:07:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_EarnType_Id]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		EarnType
	WHERE
		Id LIKE @parm1
	ORDER BY
		Id

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
