USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPEnt_PJProj]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJPEnt_PJProj]
   @Project    varchar( 16 ),
   @Task       varchar( 32 )

AS
   SELECT      *
   FROM        PJPEnt LEFT JOIN PJProj
               ON PJPEnt.Project = PJProj.Project
   WHERE       PJPEnt.Project = @Project and
               PJPEnt.PJT_Entity = @Task
   ORDER BY    PJPEnt.Project, PJPEnt.PJT_Entity
GO
