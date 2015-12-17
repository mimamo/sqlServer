USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_InvtID_SiteID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_InvtID_SiteID]
AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN WOHeader
               ON WOMatlReq.WONbr = WOHeader.WONbr
               LEFT JOIN WOTask
               ON WOMatlReq.WONbr = WOTask.WONbr and
               WOMatlReq.Task = WOTask.Task
   ORDER BY    WOMatlReq.InvtID, WOMatlReq.SiteID, WOMatlReq.WhseLoc, WOMatlReq.WONbr
GO
