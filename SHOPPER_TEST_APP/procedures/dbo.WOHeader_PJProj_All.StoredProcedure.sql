USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_PJProj_All]    Script Date: 12/21/2015 16:07:22 ******/
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
