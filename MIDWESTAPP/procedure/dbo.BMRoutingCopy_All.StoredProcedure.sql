USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMRoutingCopy_All]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMRoutingCopy_All] @KitId varchar ( 30) as
	Select * from Routing
		where KitID like @KitId
		Order by Kitid, SiteId, Status
GO
