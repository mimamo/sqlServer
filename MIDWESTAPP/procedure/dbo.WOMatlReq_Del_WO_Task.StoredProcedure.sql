USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_Del_WO_Task]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_Del_WO_Task]
   @WONbr      varchar( 16 ),
   @Task       varchar( 32 )
AS
   DELETE
   FROM        WOMatlReq
   WHERE       WONbr = @WONbr and
               Task = @Task
GO
