USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConMaster_All]    Script Date: 12/21/2015 15:43:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConMaster_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smConMaster
		,Customer
	WHERE
		MasterId LIKE @parm1
			AND
		smConMaster.CustId = Customer.CustId
	ORDER BY
		MasterId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
