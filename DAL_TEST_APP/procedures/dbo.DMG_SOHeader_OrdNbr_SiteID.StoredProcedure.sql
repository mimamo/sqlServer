USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_OrdNbr_SiteID]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_OrdNbr_SiteID]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@SiteID varchar(10)
AS
	select	distinct Site.*
	from	Site
	join	SOSched on SOSched.CpnyID = Site.CpnyID and SOSched.SiteID = Site.SiteID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	Site.SiteID like @SiteID
	order by Site.CpnyID, Site.SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
