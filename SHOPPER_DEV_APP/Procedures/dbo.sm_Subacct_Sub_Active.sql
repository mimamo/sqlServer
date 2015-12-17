USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Subacct_Sub_Active]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Subacct_Sub_Active]
		@parm1	varchar(24)
AS
	SELECT
		*
	FROM
		Subacct
	WHERE
		Sub LIKE @parm1
			AND
		Active = 1
	ORDER BY
		Sub

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
