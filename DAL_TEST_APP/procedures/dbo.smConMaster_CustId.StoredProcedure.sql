USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConMaster_CustId]    Script Date: 12/21/2015 13:57:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConMaster_CustId]
		@parm1	varchar(15)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smConMaster
	WHERE
		CustId = @parm1
			AND
		MasterId LIKE @parm2
	ORDER BY
		CustID
		,MasterId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
