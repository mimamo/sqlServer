USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Site_Name]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Site_Name]
	@parm1 varchar(10)
AS
	SELECT Name
	FROM Site
	WHERE SiteID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
