USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPTDRol_PJAcct]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJPTDRol_PJAcct]
   @Project    varchar( 16 )

AS
   SELECT      *
   FROM     PJPTDRol LEFT JOIN PJAcct
         ON PJPTDROL.Acct = PJAcct.Acct
   WHERE    PJPTDRol.Project = @Project
   ORDER BY    PJPTDRol.Project, PJPTDRol.Acct
GO
