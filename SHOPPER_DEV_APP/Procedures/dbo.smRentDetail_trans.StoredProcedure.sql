USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentDetail_trans]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentDetail_trans]
		@parm1	varchar(10)
		,@parm2Min	smallint
		,@parm2Max	smallint
AS
	SELECT
		*
	FROM
		smRentDetail
	WHERE
		TransId = @parm1
			AND
		LineID BETWEEN @parm2Min AND @parm2Max
	ORDER BY
		TransID
		,LineID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
