USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE AssetId LIKE @parm1 ORDER BY AssetId
GO
