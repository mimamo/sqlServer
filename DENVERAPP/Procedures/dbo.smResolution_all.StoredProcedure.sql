USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smResolution_all]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smResolution_all]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smResolution
	WHERE
		ResolutionID LIKE @parm1
	ORDER BY
		ResolutionID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
