USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConMaster_CustId]    Script Date: 12/16/2015 15:55:34 ******/
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
