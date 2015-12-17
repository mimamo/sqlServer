USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJPTDRol_Acct]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJPTDRol_Acct]
   @Project    varchar( 16 ),
   @Acct       varchar( 16 )

AS
   SELECT      *
   FROM     PJPTDRol
   WHERE    Project = @Project and
         Acct = @Acct
   ORDER BY    Project, Acct
GO
