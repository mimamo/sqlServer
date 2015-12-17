USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_Fetch]    Script Date: 12/16/2015 15:55:18 ******/
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
