USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCCode_all]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCCode_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM lccode
	WHERE lccode LIKE @parm1
	ORDER BY lccode

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
