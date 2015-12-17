USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConMaster_All]    Script Date: 12/16/2015 15:55:34 ******/
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
