USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WONbr_Task_InvtID_SW]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WONbr_Task_InvtID_SW]
   @WONbr         varchar( 16 ),
   @Task          varchar( 32 ),
   @InvtID        varchar( 30 ),
   @SiteID        varchar( 10 ),
   @WhseLoc       varchar( 10 )
AS
   SELECT      *
   FROM        WOMatlReq
   WHERE       WONbr = @WONbr and
               Task = @Task and
               InvtID = @InvtID and
               SiteID = @SiteID and
               WhseLoc = @WhseLoc
GO
