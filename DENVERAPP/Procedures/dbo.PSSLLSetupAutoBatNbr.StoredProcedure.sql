USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLSetupAutoBatNbr]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLSetupAutoBatNbr] AS
  SELECT LastBatNbr FROM PSSLLSetup
GO
