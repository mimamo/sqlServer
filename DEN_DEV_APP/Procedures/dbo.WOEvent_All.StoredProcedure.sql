USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOEvent_All]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOEvent_All]
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOEvent
   WHERE       WONbr LIKE @WONbr
   ORDER BY    WONbr DESC, EventID DESC
GO
