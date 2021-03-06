USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOEvent_Filter]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOEvent_Filter]
   @WONbr         varchar( 16 ),
   @PerPostbeg    varchar( 6 ),
   @PerPostend    varchar( 6 ),
   @ActionID      varchar( 3 ),
   @BatchID       varchar( 5 )
AS
   SELECT         *
   FROM           WOEvent
   WHERE          WONbr LIKE @WONbr and
                  PerPost BETWEEN @PerPostbeg and @PerPostend and
                  ActionID LIKE @ActionID and
                  BatchID LIKE @BatchID
   ORDER BY       WONbr DESC, EventID DESC
GO
