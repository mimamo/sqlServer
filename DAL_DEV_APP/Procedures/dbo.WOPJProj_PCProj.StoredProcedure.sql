USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJProj_PCProj]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJProj_PCProj]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM        PJProj
   WHERE       Status_20 = ' ' and
               Project LIKE @Project
   ORDER BY    Project
GO
