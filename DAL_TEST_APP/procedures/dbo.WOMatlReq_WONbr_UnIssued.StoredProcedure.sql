USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_WONbr_UnIssued]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_WONbr_UnIssued]
   @WONbr      varchar( 16 ),
   @Task       varchar( 32 )
AS
   SELECT      *
   FROM        WOMatlReq
   WHERE       WONbr = @WONbr and
               Task = @Task and
               QtyRemaining > 0 and
               StockUsage <> 'X'
   ORDER BY    WONbr, Task, LineNbr
GO
