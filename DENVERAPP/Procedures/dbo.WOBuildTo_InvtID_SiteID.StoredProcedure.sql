USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_InvtID_SiteID]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_InvtID_SiteID]
AS
   SELECT      *
   FROM        WOBuildTo LEFT JOIN WOHeader
   ON          WOBuildTo.WONbr = WOHeader.WONbr
   WHERE       WOBuildTo.Status = 'P'
   ORDER BY    WOBuildTo.InvtID, WOBuildTo.SiteID, WOBuildTo.WONbr
GO
