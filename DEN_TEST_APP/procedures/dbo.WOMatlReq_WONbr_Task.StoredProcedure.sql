USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WONbr_Task]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WONbr_Task]
   @WONbr         varchar( 16 ),
   @Task          varchar( 32 ),
   @LineNbrbeg    smallint,
   @LineNbrend    smallint
AS
   SELECT      *
   FROM        WOMatlReq LEFT JOIN Inventory
               ON WOMatlReq.InvtID = Inventory.InvtID
   WHERE       WONbr = @WONbr and
               Task = @Task and
               LineNbr Between @LineNbrbeg and @LineNbrend
   ORDER BY    WOMatlReq.WONbr, Task, LineNbr
GO
