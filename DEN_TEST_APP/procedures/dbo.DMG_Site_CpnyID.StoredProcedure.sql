USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_CpnyID]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Site_CpnyID]
	@CpnyID varchar(10),
	@SiteID varchar(10)
AS
	select	distinct Site.*
	from	Site
	join	LocTable on LocTable.SiteID = Site.SiteID and LocTable.SalesValid <> 'N'
	where	Site.CpnyID = @CpnyID
	and	Site.SiteID like @SiteID
	order by Site.CpnyID, Site.SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
