USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_Fetch]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Site_Fetch]
	@SiteID 	varchar(10)
as
	select	convert(smallint, S4Future09),	-- AlwaysShip
		convert(smallint, S4Future10)	-- NeverAutoCreateShippers

	from	Site
	where	SiteID = @SiteID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
