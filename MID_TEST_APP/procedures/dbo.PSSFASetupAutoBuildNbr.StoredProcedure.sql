USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFASetupAutoBuildNbr]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFASetupAutoBuildNbr] AS
  SELECT LastBuildNbr FROM PSSFASetup
GO
