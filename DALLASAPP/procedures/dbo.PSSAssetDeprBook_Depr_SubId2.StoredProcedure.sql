USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_Depr_SubId2]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_Depr_SubId2] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10) AS
  SELECT DISTINCT PSSAssetDeprBook.AssetSubID, PSSFAAssets.AssetDescr, PSSFAAssets.CpnyAssetNo, PSSAssetDeprBook.CpnyId 
  FROM PSSAssetDeprBook, PSSFAAssets 
  WHERE PSSAssetDeprBook.CpnyId = @parm1
  AND PSSAssetDeprBook.AssetId = @parm2
  AND PSSAssetDeprBook.AssetSubID LIKE @parm3
  AND DeprMethod <> ''
  AND PSSAssetDeprBook.Status = 'A'  
  AND Depreciate = 'Y'
  AND PSSAssetDeprBook.AssetId = PSSFAAssets.AssetId
  AND PSSAssetDeprBook.AssetSubID = PSSFAAssets.AssetSubID
  ORDER BY PSSAssetDeprBook.AssetSubID
GO
