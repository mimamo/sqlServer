USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServDetail_all]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--:message Creating procedure ..

CREATE PROCEDURE
	[dbo].[smServDetail_all]
		@parm1 varchar( 10 ),
		@parm2 varchar( 1 ),
		@parm3min smallint, @parm3max smallint,
		@parm4min smallint, @parm4max smallint
AS
	SELECT
		*
	FROM
		smServDetail
	WHERE
		ServiceCallID LIKE @parm1
	   		AND
	   	BillingType LIKE @parm2
	   		AND
	   	FlatRateLineNbr BETWEEN @parm3min AND @parm3max
	   		AND
	   	LineNbr BETWEEN @parm4min AND @parm4max
	ORDER BY
		   ServiceCallID,
		   BillingType,
		   FlatRateLineNbr,
		   LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
