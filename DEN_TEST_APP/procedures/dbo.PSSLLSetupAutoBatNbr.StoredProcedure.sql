USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLSetupAutoBatNbr]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLSetupAutoBatNbr] AS
  SELECT LastBatNbr FROM PSSLLSetup
GO
