USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_vendor_all]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_vendor_all]
		@parm1 	varchar(15)
AS
	SELECT
		*
	FROM
		Vendor
	WHERE
		vendid LIKE @parm1
	ORDER BY
		vendid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
