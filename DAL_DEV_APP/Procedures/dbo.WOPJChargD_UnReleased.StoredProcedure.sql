USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJChargD_UnReleased]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJChargD_UnReleased]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM        PJChargD LEFT JOIN PJChargH
               ON PJChargD.Batch_ID = PJChargH.Batch_ID
   WHERE       PJChargD.Project = @Project
   ORDER BY    PJChargD.Project, PJChargD.PJT_Entity, PJChargD.Batch_ID
GO
