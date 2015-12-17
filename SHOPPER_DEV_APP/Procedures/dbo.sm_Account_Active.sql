USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Account_Active]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Account_Active]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		Account
	WHERE
		Acct LIKE @parm1
			AND
		Active = 1
	ORDER BY
		Acct

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
