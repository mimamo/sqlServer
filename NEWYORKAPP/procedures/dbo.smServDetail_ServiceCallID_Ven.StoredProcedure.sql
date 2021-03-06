USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServDetail_ServiceCallID_Ven]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--:message Creating procedure ..
CREATE PROCEDURE
	[dbo].[smServDetail_ServiceCallID_Ven]
		@parm1 varchar( 10 ),
		@parm2 varchar( 15 ),
		@parm3min smalldatetime, @parm3max smalldatetime
AS
	SELECT
		*
	FROM
		smServDetail
	WHERE
		ServiceCallID LIKE @parm1
	   		AND
	   	VendID LIKE @parm2
	   		AND
	   	PODate BETWEEN @parm3min AND @parm3max
	ORDER BY
		ServiceCallID,
	   	VendID,
	   	PODate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
