USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_glsetup_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_glsetup_all]
AS
	SELECT
		*
	FROM
		glsetup
	ORDER BY
		setupid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
