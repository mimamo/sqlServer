USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssets_AssetId]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssets_AssetId] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssets WHERE AssetId = @parm1 AND AssetSubId LIKE @parm2 ORDER BY AssetId, AssetSubID
GO
