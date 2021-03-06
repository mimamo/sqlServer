USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_InvtID_SiteID]    Script Date: 12/16/2015 15:55:36 ******/
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
