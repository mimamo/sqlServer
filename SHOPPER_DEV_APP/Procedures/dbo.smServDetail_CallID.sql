USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServDetail_CallID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--:message Creating procedure ...
CREATE PROCEDURE
	[dbo].[smServDetail_CallID]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smServDetail
 	WHERE
		ServiceCallID = @parm1
	ORDER BY
		ServiceCallID
		,FlatRateLineNbr
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
