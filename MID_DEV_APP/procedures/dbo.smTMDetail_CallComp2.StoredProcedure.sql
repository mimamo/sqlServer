USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smTMDetail_CallComp2]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smTMDetail_CallComp2]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smTMDetail
	WHERE
		ServiceCallID = @parm1
			AND
		LineTypes IN  ('I' , 'M' , 'N')

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
