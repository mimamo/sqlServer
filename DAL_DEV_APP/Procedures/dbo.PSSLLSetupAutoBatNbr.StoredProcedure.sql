USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLSetupAutoBatNbr]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLSetupAutoBatNbr] AS
  SELECT LastBatNbr FROM PSSLLSetup
GO
