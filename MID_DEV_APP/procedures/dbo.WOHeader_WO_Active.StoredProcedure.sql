USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_WO_Active]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_WO_Active]
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader
   WHERE       Status = 'A' and
               ProcStage IN ('P','F','R') and
               WONbr LIKE @WONbr
   ORDER BY    WONbr
GO
