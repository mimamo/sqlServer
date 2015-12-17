USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Kit_Active_Sites]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ADG_Kit_Active_Sites]
	@KitID	varchar (30),
	@SiteID	varchar (10)
AS
SELECT Kit.SiteId, Site.Name
FROM Kit
	left outer join Site
		on 	Kit.SiteId = Site.SiteId
WHERE Kit.KitId like @KitID AND
	Kit.SiteId like @SiteID AND
	Kit.Status = 'A'
ORDER BY Kit.SiteId
GO
