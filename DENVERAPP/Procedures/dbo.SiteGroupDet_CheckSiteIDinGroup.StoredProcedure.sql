USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SiteGroupDet_CheckSiteIDinGroup]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SiteGroupDet_CheckSiteIDinGroup    Script Date: 1/24/08 12:30:33 PM ******/
 Create Procedure [dbo].[SiteGroupDet_CheckSiteIDinGroup]
   @parmSiteGroupID varchar (10), @parmSiteID varchar (10)
AS

   SELECT Count(*)
     FROM SiteGroupDet
    WHERE SiteGroupID <> @parmSiteGroupID 
      AND SiteID = @parmSiteID
GO
