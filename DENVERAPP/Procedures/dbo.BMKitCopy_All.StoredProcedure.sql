USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMKitCopy_All]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMKitCopy_All] @KitId varchar ( 30) as
	Select * from Kit
		where KitID like @KitId
		Order by Kitid, SiteId, Status
GO
