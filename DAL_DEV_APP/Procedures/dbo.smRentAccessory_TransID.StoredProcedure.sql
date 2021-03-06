USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentAccessory_TransID]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentAccessory_TransID]
		@parm1	varchar(10)
		,@parm2Min	smallint
		,@parm2Max 	smallint
AS
	SELECT
		*
	FROM
		smRentAccessory
	WHERE
		TransID = @parm1
			AND
		LineNbr BETWEEN @parm2Min AND @Parm2Max
	ORDER BY
		TransID
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
