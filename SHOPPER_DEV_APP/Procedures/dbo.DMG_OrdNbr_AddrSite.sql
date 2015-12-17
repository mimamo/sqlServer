USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbr_AddrSite]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_OrdNbr_AddrSite]
	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@SiteID varchar(10)
AS
	select	distinct Site.*
	from	Site
	join	SOSched ON SOSched.ShipSiteID = Site.SiteID
	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	Site.SiteID like @SiteID
	order by Site.SiteID
GO
