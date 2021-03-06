USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_Task_InvtID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_Task_InvtID]
   @WONbr         varchar( 16 ),
   @Task          varchar( 32 ),
   @InvtID        varchar( 30 )

AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN Inventory
               ON WOMatlReq.InvtID = Inventory.InvtID
   WHERE       WOMatlReq.WONbr = @WONbr and
               WOMatlReq.Task = @Task and
               WOMatlReq.InvtID LIKE @InvtID
   ORDER BY    WOMatlReq.WONbr, WOMatlReq.Task, WOMatlReq.InvtID
GO
