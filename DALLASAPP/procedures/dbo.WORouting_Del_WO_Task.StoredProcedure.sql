USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WORouting_Del_WO_Task]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORouting_Del_WO_Task]
   @WONbr      varchar( 16 ),
   @Task       varchar( 32 )
AS
   DELETE
   FROM        WORouting
   WHERE       WONbr = @WONbr and
               Task = @Task
GO
