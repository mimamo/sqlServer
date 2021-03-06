USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_CustId_SiteID]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_CustId_SiteID]
		@parm1	varchar(15)
		,@parm2	varchar(10)
		,@parm3 varchar(10)
AS
	SELECT
		*
	FROM
		smServCall (NOLOCK)
	WHERE
		CustomerId = @parm1
			AND
		ShiptoId = @parm2
			AND
		ServiceCallCompleted = 1
			AND
		smServCall.ServiceCallID LIKE @parm3
	ORDER BY
		ServiceCallDate DESC

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
