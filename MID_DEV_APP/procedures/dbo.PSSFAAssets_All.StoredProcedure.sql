USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_All]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFAAssets WHERE AssetId LIKE @parm1 ORDER BY AssetId, AssetSubId
GO
