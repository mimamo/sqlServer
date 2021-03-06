USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMKit_cpnyid]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMKit_cpnyid] @cpnyid varchar (10), @KitID varchar ( 30) as
	Select DISTINCT Kit.KitID from Kit
		INNER JOIN site ON Kit.SiteID = site.siteID
		where
		site.cpnyid = @cpnyid
		AND Kit.KitID like @KitID
		Order by Kit.Kitid
GO
