USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_glsetup_all_NoLock]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_glsetup_all_NoLock]
AS
	SELECT
		*
	FROM
		glsetup (NOLOCK)
	ORDER BY
		setupid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
