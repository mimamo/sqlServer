USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOTask_Proj]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOTask_Proj]
   @Project    varchar( 16 ),
   @Task       varchar( 32 )

AS
   SELECT      *
   FROM        PJPEnt
   WHERE       Project = @Project and
               PJT_Entity LIKE @Task
   ORDER BY    Project, PJT_Entity
GO
