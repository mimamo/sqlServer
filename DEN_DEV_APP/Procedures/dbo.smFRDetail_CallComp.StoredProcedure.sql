USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFRDetail_CallComp]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smFRDetail_CallComp]
		@parm1	varchar(10)
		,@parm2 smallint
AS
	SELECT
		*
	FROM
		smFRDetail
	WHERE
		ServiceCallID LIKE @parm1
			AND
		FlatRateLineNbr = @parm2
	 ORDER BY
		ServiceCallID
		,FlatRateLineNbr
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
