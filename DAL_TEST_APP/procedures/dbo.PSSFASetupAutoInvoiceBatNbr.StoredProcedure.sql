USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFASetupAutoInvoiceBatNbr]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFASetupAutoInvoiceBatNbr] AS
  SELECT LastInvoiceBatNbr FROM PSSFASetup
GO
