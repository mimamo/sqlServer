USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJProj_WO_Only]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJProj_WO_Only]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM        PJProj
   WHERE       Project LIKE @Project and
               PJProj.Status_20 IN ('M', 'R')
   ORDER BY    Project
GO
