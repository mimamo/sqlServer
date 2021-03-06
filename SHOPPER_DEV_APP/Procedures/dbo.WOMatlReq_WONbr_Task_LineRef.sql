USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WONbr_Task_LineRef]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WONbr_Task_LineRef]
   @WONbr         varchar( 16 ),
   @Task          varchar( 32 ),
   @LineRef			varchar( 5 )
AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN Inventory
               ON WOMatlReq.InvtID = Inventory.InvtID
   WHERE       WONbr = @WONbr and
               Task = @Task and
               LineRef LIKE @LineRef
GO
