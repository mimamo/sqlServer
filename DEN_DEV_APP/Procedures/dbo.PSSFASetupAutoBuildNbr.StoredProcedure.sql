USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFASetupAutoBuildNbr]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFASetupAutoBuildNbr] AS
  SELECT LastBuildNbr FROM PSSFASetup
GO
