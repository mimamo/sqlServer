USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_WhseLoc_Count]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_WhseLoc_Count]
	@SiteID 	varchar (10),
	@WhseLoc 	varchar (10)
AS
	SELECT	count(*)
	FROM 	LotSerMst
	WHERE	SiteID = @SiteID
	and 	WhseLoc = @WhseLoc

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
