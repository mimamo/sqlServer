USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_WOType_All]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_WOType_All]
   @WOType1    varchar( 1 ),
   @WOType2    varchar( 1 ),
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader
   WHERE       ProcStage IN (' ','R') and
               (WOType = @WOType1 or WOType = @WOType2) and
               WONbr LIKE @WONbr
   ORDER BY    WONbr
GO
