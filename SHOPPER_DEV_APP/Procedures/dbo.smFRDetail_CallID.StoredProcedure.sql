USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFRDetail_CallID]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smFRDetail_CallID]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smFRDetail
 	WHERE
		ServiceCallID = @parm1
	ORDER BY
		ServiceCallID
		,FlatRateLineNbr
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
