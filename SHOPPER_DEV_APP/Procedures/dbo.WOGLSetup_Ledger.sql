USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOGLSetup_Ledger]    Script Date: 12/16/2015 15:55:36 ******/
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
