USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SiteGroupDet_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SiteGroupDet_all    Script Date: 01/02/08 12:19:55 PM ******/
CREATE PROCEDURE [dbo].[SiteGroupDet_all] 
   @parm1 varchar( 10 ), @parm2 varchar(10)
AS
   SELECT s.*, t.Name
     FROM SiteGroupDet s JOIN Site t
                           ON s.SiteID = t.SiteID
    WHERE s.SiteGroupID LIKE @parm1 AND s.SiteID Like @Parm2
    ORDER BY s.SiteGroupID, s.SiteID
GO
