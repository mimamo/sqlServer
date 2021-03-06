USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOTask_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOTask_All]
   @WONbr      varchar( 16 ),
   @Task       varchar( 32 )
AS
   SELECT      *
   FROM        WOTask
   WHERE       WONbr = @WONbr and
               Task LIKE @Task
   ORDER BY    WONbr, Task
GO
