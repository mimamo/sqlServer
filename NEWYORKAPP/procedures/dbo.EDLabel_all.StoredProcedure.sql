USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabel_all]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDLabel_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM EDLabel
	WHERE Name LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY Name,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
