USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_vendor_all]    Script Date: 12/16/2015 15:55:33 ******/
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
