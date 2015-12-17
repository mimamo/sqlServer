USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WOHeader_WOTask_InvtID_SiteID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WOHeader_WOTask_InvtID_SiteID]
   @InvtID     varchar( 30 ),
   @SiteID     varchar( 10 )
AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN WOHeader
               ON WOMatlReq.WONbr = WOHeader.WONbr
               LEFT JOIN WOTask
               ON WOMatlReq.WONbr = WOTask.WONbr and
               WOMatlReq.Task = WOTask.Task
   WHERE       WOMatlReq.Invtid = @InvtID and
               WOMatlReq.SiteID LIKE @SiteID
   ORDER BY    WOMatlReq.WONbr, WOMatlReq.Task DESC
GO
