USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOEvent_All]    Script Date: 12/21/2015 16:07:22 ******/
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
