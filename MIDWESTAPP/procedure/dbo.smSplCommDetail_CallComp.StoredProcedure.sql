USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSplCommDetail_CallComp]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSplCommDetail_CallComp]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smSplCommDetail
	WHERE
		ServiceCallID = @parm1
	ORDER BY
		ServiceCallid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
