USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WO_Prj_IS]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WO_Prj_IS]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN WOHeader
               ON WOMatlReq.WONbr = WOHeader.WONbr
               LEFT JOIN PJProj
               ON WOMatlReq.WONbr = PJProj.Project
   WHERE       WOMatlReq.Invtid = @InvtID and
               WOMatlReq.SiteID LIKE @SiteID
   ORDER BY    WOMatlReq.WONbr DESC
GO
