USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_MfgPrj_PS_All]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_MfgPrj_PS_All]
   @ProcStage  varchar( 1 ),
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader
   WHERE       (ProcStage = ' ' or ProcStage = @ProcStage) and
               WONbr LIKE @WONbr
   ORDER BY    WONbr
GO
