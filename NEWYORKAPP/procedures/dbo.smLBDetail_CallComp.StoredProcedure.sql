USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smLBDetail_CallComp]    Script Date: 12/21/2015 16:01:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smLBDetail_CallComp]
		@parm1	varchar(10)
		,@parm2	varchar(1)
AS
	SELECT
		*
	FROM
		smLBDetail
	WHERE
		ServiceCallID = @parm1
			AND
		LineTypes = @parm2

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
