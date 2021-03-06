USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAssetDeprBook_Depr_SubId]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSAssetDeprBook_Depr_SubId] @parm1 VARCHAR(10), @parm2 VARCHAR(10), @parm3 VARCHAR(10), @parm4 VARCHAR(10) AS
  SELECT PSSAssetDeprBook.AssetSubID, PSSFAAssets.AssetDescr, PSSFAAssets.CpnyAssetNo, PSSAssetDeprBook.CpnyId 
  FROM PSSAssetDeprBook, PSSFAAssets 
  WHERE PSSAssetDeprBook.CpnyId = @parm1
  AND BookCode = @parm2
  AND PSSAssetDeprBook.AssetId = @parm3
  AND PSSAssetDeprBook.AssetSubID LIKE @parm4
  AND DeprMethod <> ''
  AND PSSAssetDeprBook.Status = 'A'  
  AND Depreciate = 'Y'
  AND PSSAssetDeprBook.AssetId = PSSFAAssets.AssetId
  AND PSSAssetDeprBook.AssetSubID = PSSFAAssets.AssetSubID
  ORDER BY PSSAssetDeprBook.AssetSubID
GO
