USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServHistory_SvcId]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServHistory_SvcId]
		@parm1	varchar(10)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smServHistory
	WHERE
		ServiceCallID LIKE @parm1
			AND
		CallStatus LIKE @parm2
	ORDER BY
		ServiceCallID
		,ChangedDate DESC
		,ChangedTime DESC
		,CallStatus

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
