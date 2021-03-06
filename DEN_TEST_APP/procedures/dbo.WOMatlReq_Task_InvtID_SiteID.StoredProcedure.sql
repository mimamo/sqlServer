USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_Task_InvtID_SiteID]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_Task_InvtID_SiteID]
   @WONbr         varchar( 16 ),
   @Task          varchar( 32 ),
   @InvtID        varchar( 30 ),
   @SiteID  		varchar( 10 )

AS
   SELECT      *
   FROM        WOMatlReq
   WHERE       WOMatlReq.WONbr = @WONbr and
               WOMatlReq.Task = @Task and
               WOMatlReq.InvtID LIKE @InvtID and
               WOMatlReq.SiteId LIKE @SiteID
GO
