USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_TimeMat_All]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_TimeMat_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smServCall
	WHERE
		ServiceCallId LIKE @parm1 AND
		cmbInvoiceType = 'T'
	ORDER BY
		ServiceCallId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
