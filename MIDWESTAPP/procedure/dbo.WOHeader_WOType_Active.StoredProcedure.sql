USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_WOType_Active]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_WOType_Active]
   @WOType     varchar( 1 ),
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader
   WHERE       ProcStage IN ('P','F','R',' ') and
               Status = 'A' and
               WOType = @WOType and
               WONbr LIKE @WONbr
   ORDER BY    WONbr
GO
