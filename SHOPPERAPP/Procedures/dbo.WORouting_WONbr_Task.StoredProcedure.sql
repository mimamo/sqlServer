USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WORouting_WONbr_Task]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORouting_WONbr_Task]
   @WONbr      varchar( 16 ),
   @Task       varchar( 32 ),
   @LineNbrbeg smallint,
   @LineNbrend smallint
AS
   SELECT      *
   FROM        WORouting LEFT JOIN Operation
               ON WORouting.OperationID = Operation.OperationID
   WHERE       WORouting.WONbr = @WONbr and
               Task = @Task and
               LineNbr Between @LineNbrbeg and @LineNbrend
   ORDER BY    WORouting.WONbr, WORouting.Task, WORouting.LineNbr
GO
