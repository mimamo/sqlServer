USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SiteGroupDet_CheckSiteIDDelete]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SiteGroupDet_CheckSiteIDDelete    Script Date: 1/24/08 12:30:33 PM ******/
 Create Procedure [dbo].[SiteGroupDet_CheckSiteIDDelete]
   @parmSiteID varchar (10)
AS

   SELECT Count(*)
     FROM SiteGroupDet
    WHERE SiteID = @parmSiteID
GO
