USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smAdjType_All]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smAdjType_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smAdjType
	WHERE
		AdjustmentId LIKE @parm1
	ORDER BY
		AdjustmentId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
