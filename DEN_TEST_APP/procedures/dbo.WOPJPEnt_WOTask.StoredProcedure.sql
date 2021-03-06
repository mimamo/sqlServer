USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPEnt_WOTask]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJPEnt_WOTask]
   @Project    varchar( 16 ),
   @Task       varchar( 32 )

AS
   SELECT      *
   FROM        PJPEnt LEFT JOIN WOTask
               ON PJPEnt.Project = WOTask.WONbr and
               PJPEnt.PJT_Entity = WOTask.Task
   WHERE       PJPEnt.Project = @Project and
               PJPEnt.PJT_Entity LIKE @Task
   ORDER BY    PJPEnt.Project, PJPEnt.PJT_Entity
GO
