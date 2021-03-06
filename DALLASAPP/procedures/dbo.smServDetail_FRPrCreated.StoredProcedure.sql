USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServDetail_FRPrCreated]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServDetail_FRPrCreated]
		@parm1	varchar(10)
		,@parm2 smallint
AS
	SELECT
		*
	FROM
		smServDetail
	WHERE
		ServiceCallID LIKE @parm1
			AND
		FlatRateLineNbr = @parm2
			AND
		PRCreated = 1
			AND
		BillingType LIKE 'F'

	 ORDER BY
		ServiceCallID
		,FlatRateLineNbr
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
