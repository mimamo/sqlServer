USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_PJProj_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_PJProj_All]
   @Status     varchar( 1 )
AS
   SELECT      *
   FROM        WOHeader LEFT JOIN PJProj
               ON WOHeader.WONbr = PJProj.Project
   WHERE       WOHeader.ProcStage = 'C' and
               WOHeader.Status LIKE @Status
   ORDER BY    WOHeader.WONbr
GO
