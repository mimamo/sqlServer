USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_ARSetup_All_NoLock]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_ARSetup_All_NoLock]
AS
	SELECT
		*
	FROM
		ARSetup (NOLOCK)
	ORDER BY
		SetupId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
