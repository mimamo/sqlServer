USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOGLSetup_Ledger]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOGLSetup_Ledger]
AS
   SELECT      *
   FROM        GLSetup LEFT JOIN Ledger
               ON GLSetup.LedgerID = Ledger.LedgerID
GO
