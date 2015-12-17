USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJProj_WO_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJProj_WO_All]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM        PJProj LEFT JOIN WOHeader
               ON PJProj.Project = WOHeader.WONbr
   WHERE       PJProj.Status_20 IN (' ', 'P') and
               PJProj.Project LIKE @Project
   ORDER BY    PJProj.Project
GO
