USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIHeader_SiteID]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIHeader_SiteID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM PIHeader
	WHERE SiteID LIKE @parm1
	ORDER BY SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
