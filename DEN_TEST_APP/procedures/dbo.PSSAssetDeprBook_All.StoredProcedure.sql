USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSAssetDeprBook WHERE AssetId LIKE @parm1 ORDER BY AssetId
GO
