USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_ARSetup_All]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_ARSetup_All]
AS
	SELECT
		*
	FROM
		ARSetup
	ORDER BY
		SetupId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
