USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Location_WhseLoc_Count]    Script Date: 12/21/2015 16:13:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Location_WhseLoc_Count]
	@SiteID 	varchar (10),
	@WhseLoc 	varchar (10)
AS
	SELECT	count(*)
	FROM 	Location
	WHERE	SiteID = @SiteID
	and 	WhseLoc = @WhseLoc

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
