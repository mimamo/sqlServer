USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_PJProj_PS_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_PJProj_PS_All]
   @ProcStage  varchar( 1 ),
   @WONbr      varchar( 16 )
AS
   SELECT      *
   FROM        WOHeader LEFT JOIN PJProj
               ON WOHeader.WONbr = PJProj.Project
   WHERE       ProcStage LIKE @ProcStage and
               WONbr LIKE @WONbr
   ORDER BY    WOHeader.WONbr
GO
