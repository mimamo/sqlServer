USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAssetsHdr_CpnyId_Active]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAssetsHdr_CpnyId_Active] @parm1 VARCHAR(10), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSFAAssetsHdr WHERE CpnyId = @parm1 AND AssetId IN (SELECT assetid FROM PSSFAAssets WHERE Status = 'A') AND AssetId LIKE @parm2 ORDER BY AssetId
GO
