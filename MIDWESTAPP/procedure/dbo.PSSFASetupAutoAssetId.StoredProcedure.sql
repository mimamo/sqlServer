USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFASetupAutoAssetId]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFASetupAutoAssetId] AS
  SELECT LastAssetId FROM PSSFASetup WHERE setupid = 'FA'
GO
