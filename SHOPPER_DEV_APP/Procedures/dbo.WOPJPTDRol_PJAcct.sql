USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPTDRol_PJAcct]    Script Date: 12/16/2015 15:55:37 ******/
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
