USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJProj_All]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJProj_All]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM     PJProj
   WHERE    Project LIKE @Project
   ORDER BY    Project
GO
