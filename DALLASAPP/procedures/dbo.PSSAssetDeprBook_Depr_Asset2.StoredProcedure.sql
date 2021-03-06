USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_Depr_Asset2]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_Depr_Asset2] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT DISTINCT PSSAssetDeprBook.AssetId, PSSFAAssetsHdr.Descr, PSSFAAssetsHdr.CpnyAssetNo, PSSAssetDeprBook.CpnyId 
  FROM PSSAssetDeprBook, PSSFAAssetsHdr 
  WHERE PSSAssetDeprBook.CpnyId = @parm1 AND PSSAssetDeprBook.AssetId LIKE @parm2 AND DeprMethod <> '' AND Status = 'A' AND Depreciate = 'Y' AND PSSAssetDeprBook.AssetId = PSSFAAssetsHdr.AssetId
  ORDER BY PSSAssetDeprBook.AssetId
GO
