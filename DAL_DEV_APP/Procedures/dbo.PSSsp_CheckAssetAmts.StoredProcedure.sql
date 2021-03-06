USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_CheckAssetAmts]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_CheckAssetAmts] AS 

DECLARE @AssetId    VARCHAR(10)
DECLARE @AssetSubID VARCHAR(10)

DECLARE csr_Assets CURSOR Static FOR
  SELECT AssetId, AssetSubID FROM PSSFAAssets

OPEN csr_Assets

FETCH NEXT FROM csr_Assets INTO @AssetId, @AssetSubID

WHILE @@FETCH_STATUS = 0

  BEGIN -- @@FETCH_STATUS = 0
    EXEC PSSsp_UpdateAssetAmts @AssetId, @AssetSubID
    FETCH NEXT FROM csr_Assets INTO @AssetId, @AssetSubID
  END	-- @@FETCH_STATUS = 0

CLOSE csr_Assets
DEALLOCATE csr_Assets
GO
