USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJAcct_All]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJAcct_All]
   @Acct       varchar( 16 )

AS
   SELECT      *
   FROM        PJAcct
   WHERE       Acct LIKE @Acct
   ORDER BY    Acct
GO
