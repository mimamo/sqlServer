USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_NonMfg_PS_All]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_NonMfg_PS_All]
   @ProcStage  varchar( 1 ),
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader
   WHERE       WOType = 'P' and
               ProcStage LIKE @ProcStage and
               WONbr LIKE @WONbr
   ORDER BY    WONbr
GO
