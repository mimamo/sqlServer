USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smTMDetail_CallComp]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smTMDetail_CallComp]
		@parm1	varchar(10)
		,@parm2	varchar(1)
AS
	SELECT
		*
	FROM
		smTMDetail
	WHERE
		ServiceCallID = @parm1
			AND
		LineTypes = @parm2

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
