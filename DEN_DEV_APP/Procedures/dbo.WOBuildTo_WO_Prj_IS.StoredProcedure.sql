USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_WO_Prj_IS]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_WO_Prj_IS]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 ),
   @Status     varchar( 1 )
AS
   SELECT      *
   FROM        WOBuildTo LEFT JOIN WOHeader
               ON WOBuildTo.WONbr = WOHeader.WONbr
               LEFT JOIN PJProj
               ON WOBuildTo.WONbr = PJProj.Project
   WHERE       WOBuildTo.InvtID = @InvtID and
               WOBuildTo.SiteID LIKE @SiteID and
               WOBuildTo.Status LIKE @Status
   ORDER BY    WOBuildTo.WONbr DESC, WOBuildTo.Status, WOBuildTo.LineNbr
GO
