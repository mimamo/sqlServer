USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Site_DiffCpnyID]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Site_DiffCpnyID]
	@CpnyID varchar(10),
	@SiteID varchar(10)
AS
	select	Count(*)
	from	Site
	where	Site.CpnyID <> @CpnyID
	and	Site.SiteID like @SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
