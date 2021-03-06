USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_InvtID_SiteID]    Script Date: 12/21/2015 15:55:47 ******/
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
